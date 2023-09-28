{
  services.nfs.server = {
    enable = true;
    exports = ''
      /home/alex/tank 10.57.1.40(rw,sync,wdelay,no_root_squash)
      /home/alex/tank 10.57.1.41(rw,sync,wdelay,no_root_squash)
    '';
  };

  networking.firewall.interfaces."nebula.averyan" = {
    allowedTCPPorts = [2049];
    allowedUDPPorts = [2049];
  };
}
