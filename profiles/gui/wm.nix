{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      # screenshots
      grim
      slurp

      # icons
      gnome3.adwaita-icon-theme
      libsForQt5.breeze-icons

      # keyring
      gnome.seahorse
      gnome.gnome-keyring
      gcr
    ];

    fonts.fontconfig.enable = true;
    services.gpg-agent.pinentryFlavor = "gnome3";
    services.gnome-keyring.enable = true;
  };

  programs.dconf.enable = true;
}
