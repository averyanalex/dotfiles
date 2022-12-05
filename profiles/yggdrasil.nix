{ lib, pkgs, ... }:
{
  services.av-yggdrasil = {
    enable = true;
    persistentKeys = true;
    keysPath = "/persist/etc/yggdrasil/keys.json";
    settings = {
      Peers = [
        "tls://ygg.averyan.ru:8362"
      ];
      IfName = "ygg0";
    };
    denyDhcpcdInterfaces = [ "ygg0" ];
  };
}
