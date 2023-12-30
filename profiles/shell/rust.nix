{pkgs, ...}: {
  home-manager.users.alex = {
    home.file.".cargo/config.toml".text = ''
      [build]
      rustc-wrapper = "sccache"
      [target.x86_64-unknown-linux-gnu]
      linker = "clang"
      rustflags = [
        "-Clink-args=-fuse-ld=mold -Wl,--compress-debug-sections=zstd",
        "-Ctarget-cpu=native"
      ]
      [profile.dev]
      opt-level = 1
      [profile.dev.package."*"]
      debug = false
      opt-level = 3
    '';

    home.packages = with pkgs; [
      sccache
      clang
      mold-wrapped
    ];
  };
}
