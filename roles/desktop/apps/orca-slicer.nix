{ pkgs, ... }:
let
  mergedBambuCa = import ../bambu-certs/package.nix { inherit pkgs; };

  # The 2.4.2 nixpkgs recipe pins Boost 1.86, but current OpenVDB uses 1.89.
  # Keep Orca on the same Boost ABI so both versions are not loaded at once.
  boost = pkgs.boost.override {
    enableShared = true;
    enableStatic = false;
    extraFeatures = [
      "log"
      "thread"
      "filesystem"
    ];
  };

  wxGTK =
    (pkgs.wxwidgets_3_3.override {
      withPrivateFonts = true;
      withWebKit = true;
      withEGL = true;
    }).overrideAttrs
      (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libsecret ];
        configureFlags = old.configureFlags ++ [
          "--enable-debug=no"
          "--enable-secretstore"
        ];
      });

  # Current Orca main requires wxInspector even in release builds, where its
  # UI is disabled. It is not packaged in nixpkgs yet.
  wxInspector = pkgs.stdenv.mkDerivation {
    pname = "wxInspector";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://github.com/Noisyfox/wxInspector/archive/refs/tags/v1.0.0.zip";
      hash = "sha256-C6FjlW8tRosZqRuWxaumbulhCEPqQd2mKOpEza/efbc=";
    };

    nativeBuildInputs = [
      pkgs.cmake
      pkgs.pkg-config
      pkgs.unzip
      wxGTK
    ];
    buildInputs = [
      pkgs.gtk3
      wxGTK
    ];

    cmakeFlags = [
      (pkgs.lib.cmakeBool "wxBUILD_SAMPLES" false)
      (pkgs.lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DwxDEBUG_LEVEL=0")
    ];
  };

  orca-slicer-main = pkgs.orca-slicer.overrideAttrs (old: {
    version = "unstable-2026-08-26";

    src = pkgs.fetchFromGitHub {
      owner = "OrcaSlicer";
      repo = "OrcaSlicer";
      rev = "5552ed6cf1383a58321b2196317fe0c69a78b1a6";
      hash = "sha256-RB722SVMqj0Zb9PVTOhrVTTDVfcc/mZulkgfarKmlrI=";
    };

    # Current main moved the OpenCV link block, so replace the stale nixpkgs
    # patch with an equivalent patch rebased onto the pinned revision.
    patches =
      pkgs.lib.filter (patch: !(pkgs.lib.hasInfix "dont-link-opencv-world-orca.patch" (toString patch))) (
        old.patches or [ ]
      )
      ++ [
        ./patches/orca-slicer-dont-link-opencv-world.patch
        (pkgs.fetchpatch {
          name = "x2d-ams-sync-filament-arrays.patch";
          url = "https://github.com/AveryanAlex/OrcaSlicer/commit/c5cd4a8f4b0d5432814c38c6696cefa9343d9f38.patch";
          hash = "sha256-z8LqYcGMPFlb35R/1+HG6FnL1rxFQpA+ahMq0M+o9Bw=";
        })
        (pkgs.fetchpatch {
          name = "orca-cloud-api-https.patch";
          url = "https://github.com/AveryanAlex/OrcaSlicer/commit/67ff6bd34bae10dfadaa83d3f641d05f1d65ae77.patch";
          hash = "sha256-6RHl6cT4V6HPuLEtF85Z2poisDnwNSzuR3s0YZobsiw=";
        })
      ];

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.python312 ];

    # gcc-unwrapped exposes only libstdc++.a in its top-level lib directory.
    # When it precedes Clang's shared runtime, Orca embeds a second libstdc++;
    # Bambu's downloaded network plugin then corrupts std::locale across the
    # static/shared ABI boundary. Clang already provides the needed GCC headers
    # and shared runtime, so the inherited input is both redundant and unsafe.
    buildInputs =
      pkgs.lib.filter (
        input: (input.pname or "") != "boost" && (toString input) != (toString pkgs.gcc-unwrapped)
      ) (old.buildInputs or [ ])
      ++ [
        # Boost's default output is `dev`; CMake also needs component libraries.
        boost.out
        pkgs.boost.dev
        pkgs.assimp
        pkgs.python312
        wxInspector
      ];

    env = old.env // {
      NIX_LDFLAGS = toString [
        "-ludev"
        "-L${boost}/lib"
        "-lboost_log"
        "-lboost_log_setup"
      ];
    };

    # Main expects its dependency build to provide a bundled Python 3.12.13.
    # Point both configure and the post-build staging step at nixpkgs' 3.12
    # runtime instead, while tracking its patch release.
    #
    # Boost.System is header-only in nixpkgs' Boost 1.89, so there is no
    # boost_system CMake component or shared library to request. Orca and its
    # bundled FindOpenVDB module still list the obsolete compiled component.
    #
    # Boost 1.89 also removed the old Asio io_service alias and deprecated
    # member/timer APIs, made resolver results an explicit iterator range, and
    # moved the original Boost.Process API under its v1 compatibility
    # namespace. These source substitutions keep current Orca main building
    # against the one Boost version selected above; they can go away after
    # upstream migrates.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'set(_bundled_python_version "3.12.13")' \
          'set(_bundled_python_version "${pkgs.python312.version}")' \
        --replace-fail 'set(_bundled_python_root "''${CMAKE_PREFIX_PATH}/libpython")' \
          'set(_bundled_python_root "${pkgs.python312}")'
      substituteInPlace src/CMakeLists.txt \
        --replace-fail '"''${CMAKE_PREFIX_PATH}/libpython"' \
          '"''${_bundled_python_root}"'
      substituteInPlace CMakeLists.txt \
        --replace-fail 'COMPONENTS system filesystem' \
          'COMPONENTS filesystem'
      substituteInPlace cmake/modules/FindOpenVDB.cmake \
        --replace-fail 'COMPONENTS iostreams system' \
          'COMPONENTS iostreams' \
        --replace-fail $'  Boost::system\n' '''
      for asio_source in \
        src/libslic3r/GCodeSender.cpp \
        src/slic3r/GUI/HttpServer.hpp \
        src/slic3r/GUI/WebUserLoginDialog.cpp \
        src/slic3r/Utils/Bonjour.cpp \
        src/slic3r/Utils/Bonjour.hpp \
        src/slic3r/Utils/Serial.hpp
      do
        substituteInPlace "$asio_source" \
          --replace-fail 'boost::asio::io_service' \
            'boost::asio::io_context'
      done
      substituteInPlace src/libslic3r/GCodeSender.hpp \
        --replace-fail 'asio::io_service' \
          'asio::io_context'
      substituteInPlace src/slic3r/Utils/Serial.cpp \
        --replace-fail 'asio::io_service' \
          'asio::io_context' \
        --replace-fail 'io_service.reset();' \
          'io_service.restart();' \
        --replace-fail 'asio::deadline_timer' \
          'asio::steady_timer' \
        --replace-fail 'timer.expires_from_now(boost::posix_time::milliseconds(timeout));' \
          'timer.expires_after(std::chrono::milliseconds(timeout));'
      substituteInPlace src/slic3r/Utils/Bonjour.cpp \
        --replace-fail '#include <cstdint>' \
          $'#include <chrono>\n#include <cstdint>' \
        --replace-fail 'io_service->post(' \
          'boost::asio::post(*io_service, ' \
        --replace-fail 'asio::deadline_timer' \
          'asio::steady_timer' \
        --replace-fail 'timer.expires_from_now(boost::posix_time::seconds(timeout));' \
          'timer.expires_after(std::chrono::seconds(timeout));'
      substituteInPlace src/slic3r/Utils/TCPConsole.cpp \
        --replace-fail 'endpoints->endpoint()' \
          'endpoints.begin()->endpoint()'
      substituteInPlace src/slic3r/GUI/PostProcessor.cpp \
        --replace-fail '#include <boost/process.hpp>' \
          '#include <boost/process/v1.hpp>' \
        --replace-fail 'namespace process = boost::process;' \
          'namespace process = boost::process::v1;'
      for process_source in \
        src/slic3r/GUI/MediaPlayCtrl.cpp \
        src/slic3r/GUI/ProcessRunner.cpp \
        src/slic3r/GUI/ProcessRunner.hpp \
        src/slic3r/GUI/RemovableDriveManager.cpp \
        src/slic3r/plugin/PluginLoader.cpp
      do
        substituteInPlace "$process_source" \
          --replace-fail '#include <boost/process.hpp>' \
            '#include <boost/process/v1.hpp>'
      done
      for process_source in \
        src/slic3r/GUI/MediaPlayCtrl.cpp \
        src/slic3r/GUI/ProcessRunner.cpp \
        src/slic3r/plugin/PluginLoader.cpp
      do
        substituteInPlace "$process_source" \
          --replace-fail '#include <boost/process/windows.hpp>' \
            '#include <boost/process/v1/windows.hpp>'
      done
      substituteInPlace src/slic3r/GUI/ProcessRunner.cpp \
        --replace-fail '#include <boost/process/env.hpp>' \
          '#include <boost/process/v1/env.hpp>' \
        --replace-fail 'namespace bp = boost::process;' \
          'namespace bp = boost::process::v1;'
      substituteInPlace src/slic3r/plugin/PluginLoader.cpp \
        --replace-fail 'namespace process = boost::process;' \
          'namespace process = boost::process::v1;'
      for process_source in \
        src/slic3r/GUI/MediaPlayCtrl.cpp \
        src/slic3r/GUI/ProcessRunner.hpp \
        src/slic3r/GUI/RemovableDriveManager.cpp
      do
        substituteInPlace "$process_source" \
          --replace-fail 'boost::process::' \
            'boost::process::v1::'
      done
      substituteInPlace src/slic3r/Utils/Process.cpp \
        --replace-fail '#include <boost/process/spawn.hpp>' \
          '#include <boost/process/v1/spawn.hpp>' \
        --replace-fail '#include <boost/process/args.hpp>' \
          '#include <boost/process/v1/args.hpp>' \
        --replace-fail 'boost::process::spawn' \
          'boost::process::v1::spawn'
    '';

    # Prevent CMake from downloading uv in the network-isolated Nix build.
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      (pkgs.lib.cmakeFeature "ORCA_BUNDLED_UV_EXECUTABLE" "${pkgs.uv}/bin/uv")
    ];

    postInstall = (old.postInstall or "") + ''
      install -Dm0644 ${mergedBambuCa}/share/bambu-certs/printer.cer \
        "$out/share/OrcaSlicer/cert/printer.cer"
    '';
  });
in
{
  hm.home.packages = [ orca-slicer-main ];
}
