{pkgs, ...}: {
  nixcfg.gnome.enable = true;
  services.xserver = {
    xkb.layout = "us,ru";
    xkb.options = "grp:caps_toggle,grp_led:scroll";
  };

  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

  xdg.portal = {
    # extraPortals = [pkgs.xdg-desktop-portal-gnome];
    xdgOpenUsePortal = true;
  };

  hm = {
    # home.packages = with pkgs; [
    #   # screenshots
    #   grim
    #   slurp

    #   # icons
    #   adwaita-icon-theme
    #   libsForQt5.breeze-icons

    #   # keyring
    #   seahorse
    #   gcr
    # ];

    services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
    services.gnome-keyring.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/mutter" = {
        experimental-features = ["scale-monitor-framebuffer" "x11-randr-fractional-scaling"];
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
      # "org/gnome/desktop/wm/preferences" = {
      #   button-layout = "appmenu:minimize,maximize,close";
      # };
      # "org/gnome/desktop/interface" = {
      #   font-antialiasing = "rgba";
      # };
      # "org/gnome/shell" = {
      # enabled-extensions = ["dash-to-dock@micxgx.gmail.com"];
      # favorite-apps = [
      #   "org.gnome.Console.desktop"
      #   "org.gnome.Calendar.desktop"
      #   "thunderbird.desktop"
      #   "org.gnome.Nautilus.desktop"
      #   "firefox.desktop"
      # ];
      # };
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    gtk = {
      enable = true;

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      style.name = "adwaita-dark";
    };
  };

  persist.state.homeDirs = [".local/share/keyrings"];

  programs.dconf.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    geary
    gnome-calendar
    epiphany
  ];

  # programs.gnome-disks.enable = false;
}
