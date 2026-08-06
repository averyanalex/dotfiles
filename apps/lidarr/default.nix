let
  name = "lidarr";
  sliceName = "apps-${name}";
  appServiceConfig = {
    Slice = "${sliceName}.slice";
    RestartMode = "direct";
    RestartSec = "5s";
    TimeoutStartSec = "4min";
  };
  appUnitConfig = {
    StartLimitIntervalSec = "10min";
    StartLimitBurst = 6;
  };
in
{ config, ... }:
{
  systemd.slices.${sliceName}.description = "Lidarr application services";

  systemd.tmpfiles.rules = [
    "d /persist/${name}/config 700 1000 100 - -"
  ];

  services.nginx.virtualHosts."lidarr.averyan.ru" = {
    useACMEHost = "averyan.ru";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://10.90.90.2:8686";
      proxyWebsockets = true;
    };
  };

  networking.tproxy.forward."pme-${name}" = { };

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      containers = {
        ${name} = {
          containerConfig = {
            image = "ghcr.io/linuxserver-labs/prarr:lidarr-plugins";
            autoUpdate = "registry";
            memory = "8g";
            networks = [ networks.${name}.ref ];
            ip = "10.90.90.2";
            volumes = [
              "/persist/${name}/config:/config"
              "/home/alex/tank/hot:/home/alex/tank/hot"
              # "/home/alex/tank/hot:/data"
            ];
            environments = {
              PUID = "1000";
              PGID = "100";
              TZ = "Europe/Moscow";
            };
            # container gid 100 -> host 100 so PGID=100 matches your group
            gidMaps = [
              "0:100000:100"
              "100:100:1"
              "101:100101:98999"
            ];
            uidMaps = [
              "0:100000:1000"
              "1000:1000:1"
              "1001:101001:98999"
            ];
          };
          unitConfig = appUnitConfig;
          serviceConfig = appServiceConfig;
        };
      };

      networks = {
        ${name} = {
          networkConfig = {
            subnets = [ "10.90.90.0/24" ];
            podmanArgs = [ "--interface-name=pme-${name}" ];
          };
          serviceConfig.Slice = appServiceConfig.Slice;
        };
      };
    };

  networking.firewall.extraForwardRules = ''
    iifname pme-${name} oifname pme-slskd accept
    iifname pme-${name} oifname pme-qbit accept
  '';
}
