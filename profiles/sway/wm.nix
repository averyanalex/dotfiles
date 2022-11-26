{ config, pkgs, lib, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      # screenshots
      grim
      slurp

      # clipboard
      wl-clipboard

      # icons
      gnome3.adwaita-icon-theme
      libsForQt5.breeze-icons

      # keyring
      gnome.seahorse
      gnome.gnome-keyring
      gcr

      # fonts
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont
      noto-fonts-emoji
      noto-fonts-cjk
      meslo-lgs-nf
      jetbrains-mono

      # volume control
      pulseaudio
    ];

    fonts.fontconfig.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        font.normal.family = "MesloLGS NF";
      };
    };

    services.gpg-agent.pinentryFlavor = "qt"; # TODO: fix gnome3 pinentry

    services.gnome-keyring.enable = true;
  };
}
