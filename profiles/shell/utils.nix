{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      xdg-ninja
      ncdu
      killall
      btop
      htop
      smartmontools

      usbutils
      pciutils

      traceroute

      unzip

      rmlint
    ];
  };
}
