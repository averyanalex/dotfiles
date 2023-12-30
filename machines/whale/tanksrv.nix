{
  services.nfs.server = {
    enable = true;
    exports = ''      /
            /home/alex/tank 10.57.1.40(rw,sync,wdelay,no_root_squash,nohide,crossmnt)
            /home/alex/tank 10.57.1.41(rw,sync,wdelay,no_root_squash,nohide,crossmnt)
            /home/alex/tank/bruh 201:538e:d942:43f3:3f47:7d56:40f0:3418/128(rw,sync,wdelay,no_root_squash)
    '';
  };

  networking.firewall.interfaces."nebula.averyan" = {
    allowedTCPPorts = [2049];
    allowedUDPPorts = [2049];
  };

  # networking.firewall.interfaces."ygg0" = {
  #     allowedTCPPorts = [2049];
  #     allowedUDPPorts = [2049];
  #   };
}
