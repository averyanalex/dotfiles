{ lib, pkgs, ... }:
let
  listenAddress = "10.57.1.42";
  proxies = {
    serv1 = {
      listenPort = 3122;
      target = "serv1.asc.rssi.ru:22";
    };
    git = {
      listenPort = 3123;
      target = "git.asc.rssi.ru:22";
    };
    serv2 = {
      listenPort = 3124;
      target = "serv2.asc.rssi.ru:22";
    };
  };

  socketName = name: "ssh-proxy-${name}";
in
{
  systemd.sockets = lib.mapAttrs' (
    name: proxy:
    lib.nameValuePair (socketName name) {
      description = "Nebula TCP proxy for ${proxy.target}";
      wantedBy = [ "sockets.target" ];
      wants = [ "nebula@averyan.service" ];
      after = [ "nebula@averyan.service" ];
      listenStreams = [ "${listenAddress}:${toString proxy.listenPort}" ];
      socketConfig.FreeBind = true;
    }
  ) proxies;

  systemd.services = lib.mapAttrs' (
    name: proxy:
    lib.nameValuePair (socketName name) {
      description = "Nebula TCP proxy to ${proxy.target}";
      serviceConfig = {
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd ${proxy.target}";
        DynamicUser = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
      };
    }
  ) proxies;

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = map (proxy: proxy.listenPort) (
    lib.attrValues proxies
  );
}
