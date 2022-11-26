{ lib, pkgs, ... }:
{
  services.yggdrasil = {
    enable = true;
    group = "wheel";
    # package = pkgs.unstable.yggdrasil;
    persistentKeys = true;
    config = {
      Peers = [
        "tls://ygg.averyan.ru:8362"
      ];
      IfName = "ygg0";
    };
  };

  systemd.services.yggdrasil = {
    # preStart = lib.mkBefore "mkdir /run/yggdrasil";
    wants = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];
  };

  persist.state.dirs = [ "/var/lib/yggdrasil" ];
}
