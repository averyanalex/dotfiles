{
  config,
  pkgs,
  lib,
  ...
}: {
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

    programs.alacritty = {
      enable = true;
      settings = {
        font.normal.family = "MesloLGS NF";
      };
    };

    services.gpg-agent.pinentryFlavor = "gnome3";

    services.gnome-keyring.enable = true;
  };
}
