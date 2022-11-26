{ pkgs, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      unstable.xdg-ninja
      ncdu
      killall
      btop
      htop

      unzip
    ];
  };
}
