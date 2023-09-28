{
  config,
  lib,
  ...
}: {
  services.yggdrasil = {
    enable = true;
    openMulticastPort = true;
    settings = {
      Listen = ["tls://[::]:8362" "tcp://[::]:8363"];
      Peers = lib.mkIf (config.networking.hostName != "whale") [
        "tcp://ygg-msk-1.averyan.ru:8363"
      ];
      IfName = "ygg0";
      MulticastInterfaces = [
        {
          Port = 9217;
        }
      ];
      NodeInfo = {
        name = "${config.networking.hostName}.averyanalex";
      };
    };
    denyDhcpcdInterfaces = ["ygg0"];
  };

  networking.firewall.allowedTCPPorts = [8362 8363 9217];
}
