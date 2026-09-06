{ pkgs, ... }:
{
  systemd.sockets.serv2-proxy = {
    description = "Public TCP proxy for serv2 SSH";
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "0.0.0.0:3124" ];
  };

  systemd.services.serv2-proxy = {
    description = "Public TCP proxy to serv2 through mole";
    wants = [ "nebula@averyan.service" ];
    after = [ "nebula@averyan.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 10.57.1.42:3124";
      DynamicUser = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3124 ];
}
