let
  name = "open-webui";
  mcpName = "semantic-scholar-mcp";
  sliceName = "apps-${name}";
  uidMaps = [ "0:100000:100000" ];
  gidMaps = [ "0:100000:100000" ];
  appServiceConfig = {
    Slice = "${sliceName}.slice";
    RestartMode = "direct";
    RestartSec = "5s";
    TimeoutStartSec = "4min";
    TimeoutStopSec = "2min";
  };
  appUnitConfig = {
    StartLimitIntervalSec = "10min";
    StartLimitBurst = 6;
  };
in
{ config, ... }:
{
  systemd.tmpfiles.rules = [
    "d /persist/${name} 700 0 0 - -"
    "d /persist/${name}/data 700 100000 100000 - -"
  ];

  systemd.slices.${sliceName} = {
    description = "Open WebUI application services";
    sliceConfig.MemoryMax = "4G";
  };

  age.secrets.${name}.file = ./main.age;

  networking.tproxy.forward."pme-${name}" = { };

  services.nginx.virtualHosts."llm.averyan.ru" = {
    useACMEHost = "averyan.ru";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://10.90.101.2:8080";
      proxyWebsockets = true;
    };
  };

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
      commonConfig = {
        inherit uidMaps gidMaps;
        networks = [ networks.${name}.ref ];
      };
    in
    {
      networks.${name} = {
        networkConfig = {
          subnets = [ "10.90.101.0/24" ];
          podmanArgs = [ "--interface-name=pme-${name}" ];
        };
        serviceConfig.Slice = appServiceConfig.Slice;
      };

      containers = {
        ${mcpName} = {
          containerConfig = commonConfig // {
            image = "ghcr.io/averyanalex/semantic-scholar-graph-api@sha256:7ac8d46475e59d064bdf9229d951f571fdd4931dbb7f2f2cd9f25611a74e11e1";
            memory = "256m";
            ip = "10.90.101.3";
            networkAliases = [ mcpName ];
            healthCmd = "python -c \"import socket; socket.create_connection(('127.0.0.1', 3000), 3).close()\"";
            healthInterval = "30s";
            healthTimeout = "10s";
            healthRetries = 3;
            healthStartPeriod = "5s";
            healthOnFailure = "kill";
            notify = "healthy";
            stopTimeout = 30;
          };
          unitConfig = appUnitConfig;
          serviceConfig = appServiceConfig;
        };

        ${name} = {
          containerConfig = commonConfig // {
            image = "ghcr.io/open-webui/open-webui:main";
            autoUpdate = "registry";
            memory = "3g";
            ip = "10.90.101.2";
            networkAliases = [ name ];
            volumes = [ "/persist/${name}/data:/app/backend/data" ];
            environments.OLLAMA_BASE_URL = "http://ollama:11434";
            environmentFiles = [ config.age.secrets.${name}.path ];
            addHosts = [ "host.docker.internal:host-gateway" ];
            healthCmd = "curl --silent --fail http://localhost:8080/health | jq -ne 'input.status == true' || exit 1";
            healthInterval = "30s";
            healthTimeout = "10s";
            healthRetries = 5;
            healthStartPeriod = "60s";
            healthOnFailure = "kill";
            notify = "healthy";
            stopTimeout = 60;
          };
          unitConfig = appUnitConfig // {
            Wants = [ "${mcpName}.service" ];
            After = [ "${mcpName}.service" ];
          };
          serviceConfig = appServiceConfig;
        };
      };
    };
}
