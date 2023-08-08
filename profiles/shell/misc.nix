{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      xdg-ninja # clean home dir
      ncdu # disk usage analyze
      killall # kill all processes by name
      btop # beautiful cpu, net, disk monitor
      htop # simple cpu monitor
      smartmontools # SMART data reader
      usbutils # lsusb
      pciutils # lspci
      traceroute # show route trace to host
      unzip # unarchive zip
      rmlint # find dupes
      neofetch # I am hacker
      ripgrep # fast grep
      iotop # disk usage monitor
      nmap # open ports analyzer
      stress # cpu stress test
      screen # run in background
      hashcat # password cracking
      micro # simple text editor
    ];

    home.sessionVariables = {
      EDITOR = "micro";
    };
  };
}
