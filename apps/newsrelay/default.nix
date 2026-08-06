{ config, ... }:
let
  name = "newsrelay";
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
{
  systemd.slices.${sliceName}.description = "NewsRelay application services";

  systemd.tmpfiles.rules = [
    "d /persist/${name}/data 700 100999 100999 - -"
  ];

  age.secrets."${name}-bot" = {
    file = ./bot.age;
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
            image = "ghcr.io/averyanalex/newsrelay:latest";
            memory = "2g";
            # autoUpdate = "registry";
            networks = [ networks.${name}.ref ];
            ip = "10.90.89.2";
            environments = {
              TZ = "Europe/Moscow";
            };
            volumes = [ "/persist/${name}/data:/data" ];
            environmentFiles = [ config.age.secrets."${name}-bot".path ];
            gidMaps = [ "0:100000:100000" ];
            uidMaps = [ "0:100000:100000" ];
          };
          unitConfig = appUnitConfig;
          serviceConfig = appServiceConfig;
        };
      };

      networks = {
        ${name} = {
          networkConfig = {
            subnets = [ "10.90.89.0/24" ];
            podmanArgs = [ "--interface-name=pme-${name}" ];
          };
          serviceConfig.Slice = appServiceConfig.Slice;
        };
      };
    };
}
