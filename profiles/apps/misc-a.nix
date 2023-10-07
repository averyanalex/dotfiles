{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      # Communication
      schildichat-desktop # electron matrix client
      # fractal-next # gtk matrix client
      webcord-vencord # discord client
      telegram-desktop # telegram client

      # Creativity
      libsForQt5.kdenlive # video editor
      mediainfo # idk but kdenlive depends on it
      obs-studio # recording and streaming
      gimp # image editor
      krita # painting program

      # Finance
      monero-gui # anonymous crypto

      # Notes
      joplin-desktop # markdown notes
      openboard # qt whiteboard
      rnote # gtk whiteboard

      # LaTeX
      texstudio
      texlive.combined.scheme-full
      hunspell
      hunspellDicts.en-us
      hunspellDicts.ru-ru

      # File viewers
      gthumb # gtk image viewer
      evince # gnome document viewer
      f3d # simple 3d viewer

      # 3D modeling
      openscad
      freecad
      blender
      gmsh
      calculix
      elmerfem

      # Etc
      tor-browser-bundle-bin # anonymous browsing
      libreoffice-fresh # office
      octaveFull # math software
      kgraphviewer # graphviz viewer
      stellarium # planetarium
      kleopatra # gpg gui
      spek # audio file spectrogram
      kmplot
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
  };

  persist.state.homeDirs = [
    ".config/SchildiChat"
    ".config/WebCord"
    ".local/share/TelegramDesktop"

    "Monero"
    ".bitmonero"
    ".config/monero-project"

    ".config/Joplin"
    ".config/joplin-desktop"
    ".local/share/OpenBoard"

    ".local/share/tor-browser"
  ];
}
