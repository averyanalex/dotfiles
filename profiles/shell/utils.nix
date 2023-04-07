{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      xdg-ninja
      ncdu
      killall
      btop
      htop
      smartmontools

      usbutils # lsusb
      pciutils # lspci

      traceroute

      unzip

      rmlint # find dupes

      neofetch

      ripgrep # fast grep
    ];
  };
}
