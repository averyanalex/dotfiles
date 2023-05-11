{pkgs, ...}: {
  services.xserver = {
    enable = true;

    displayManager = {
      autoLogin.user = "olga";
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    desktopManager.gnome.enable = true;

    layout = "ru,us";
    xkbOptions = "grp:win_space_toggle";
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      baobab
      gnome-connections
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-terminal
      hitori # sudoku game
      iagno # go game
      simple-scan
      tali # poker game
      totem # video player
    ]);

  programs.gnome-disks.enable = false;

  environment.systemPackages = [pkgs.gnomeExtensions.dash-to-dock];

  home-manager.users.olga.dconf.settings = {
    "org/gnome/desktop/background" = {
      # picture-uri = "file://${../../assets/wallpaper.png}";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = true;
      extend-height = true;
      show-trash = false;
      show-mounts-only-mounted = false;
      disable-overview-on-startup = true;
    };

    "org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer" "x11-randr-fractional-scaling"];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/interface" = {
      font-antialiasing = "rgba";
    };
    "org/gnome/shell" = {
      enabled-extensions = ["dash-to-dock@micxgx.gmail.com"];
    };
  };
}
