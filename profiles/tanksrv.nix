{
  services.nfs.server = {
    enable = true;
    exports = ''
      /tank 10.5.3.101(rw,sync,wdelay,no_root_squash)
      /tank 10.5.3.100(rw,sync,wdelay,no_root_squash)
    '';
  };

  networking.firewall.interfaces."nebula.averyan" = {
    allowedTCPPorts = [ 2049 ];
    allowedUDPPorts = [ 2049 ];
  };
}
