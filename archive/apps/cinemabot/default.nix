let
  name = "cinemabot";
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
  systemd.slices.${sliceName}.description = "Cinemabot application services";

  systemd.tmpfiles.rules = [
    "d /persist/${name}/data 700 100999 100999 - -"
    "d /persist/${name}/searxng 700 100977 100977 - -"
  ];

  age.secrets."${name}-bot".file = ./bot.age;

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      containers = {
        "${name}-searxng" = {
          containerConfig = {
            image = "docker.io/searxng/searxng:latest";
            autoUpdate = "registry";
            memory = "8g";
            networks = [ networks.${name}.ref ];
            ip = "10.90.87.3";
            volumes = [ "/persist/${name}/searxng:/etc/searxng" ];
            gidMaps = [ "0:100000:100000" ];
            uidMaps = [ "0:100000:100000" ];
          };
          unitConfig = appUnitConfig;
          serviceConfig = appServiceConfig;
        };

        "${name}-bot" = {
          containerConfig = {
            image = "ghcr.io/averyanalex/cinemabot:latest";
            autoUpdate = "registry";
            memory = "2g";
            networks = [ networks.${name}.ref ];
            ip = "10.90.87.2";
            volumes = [ "/persist/${name}/data:/app/data" ];
            environments = {
              APP__SEARXNG__URL = "http://${name}-searxng:8080/";
            };
            environmentFiles = [ config.age.secrets."${name}-bot".path ];
            gidMaps = [ "0:100000:100000" ];
            uidMaps = [ "0:100000:100000" ];
          };
          unitConfig = appUnitConfig // rec {
            Requires = [ "${name}-searxng.service" ];
            After = Requires;
          };
          serviceConfig = appServiceConfig // {
            Environment = [ "REGISTRY_AUTH_FILE=${config.environment.sessionVariables.REGISTRY_AUTH_FILE}" ];
          };
        };
      };

      networks = {
        ${name} = {
          networkConfig = {
            subnets = [ "10.90.87.0/24" ];
            podmanArgs = [ "--interface-name=pme-cine" ];
          };
          serviceConfig.Slice = appServiceConfig.Slice;
        };
      };
    };
}
