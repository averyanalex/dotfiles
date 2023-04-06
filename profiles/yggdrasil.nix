{
  config,
  lib,
  pkgs,
  ...
}: {
  services.av-yggdrasil = {
    enable = true;
    persistentKeys = true;
    keysPath = "/persist/etc/yggdrasil/keys.json";
    settings = {
      Listen = ["tls://[::]:8362"];
      Peers = lib.mkIf (config.networking.hostName != "hawk") [
        "tls://ygg.averyan.ru:8362"
      ];
      IfName = "ygg0";
    };
    denyDhcpcdInterfaces = ["ygg0"];
  };

  networking.firewall.allowedTCPPorts = [8362];
}
