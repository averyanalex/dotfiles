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

    services.gpg-agent.pinentryFlavor = "gnome3";
    services.gnome-keyring.enable = true;
  };

  persist.state.homeDirs = [".local/share/keyrings"];

  programs.dconf.enable = true;
}
