{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      # screenshots
      grim
      slurp

      # icons
      adwaita-icon-theme
      libsForQt5.breeze-icons

      # keyring
      seahorse
      gnome-keyring
      gcr
    ];

    services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
    services.gnome-keyring.enable = true;
  };

  persist.state.homeDirs = [".local/share/keyrings"];

  programs.dconf.enable = true;
}
