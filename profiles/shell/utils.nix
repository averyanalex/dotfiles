{ pkgs, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      xdg-ninja
      ncdu
      killall
      btop
      htop

      usbutils
      pciutils

      traceroute

      unzip
    ];
  };
}
