let
  name = "bambuddy";
  sliceName = "apps-${name}";
  appServiceConfig = {
    Slice = "${sliceName}.slice";
    RestartMode = "direct";
    RestartSec = "5s";
    TimeoutStartSec = "4min";
    TimeoutStopSec = "1min";
  };
  appUnitConfig = {
    StartLimitIntervalSec = "10min";
    StartLimitBurst = 6;
  };
  virtualPrinterFirewall = {
    allowedTCPPorts = [
      322
      990
      3000
      3002
      6000
      8883
      2024
      2025
      2026
    ];
    allowedTCPPortRanges = [
      {
        from = 50000;
        to = 50100;
      }
    ];
    allowedUDPPorts = [ 2021 ];
  };
in
{
  systemd.slices.${sliceName}.description = "Bambuddy application services";

  systemd.tmpfiles.rules = [
    "d /persist/${name} 700 0 0 - -"
    "d /persist/${name}/data 700 101000 101000 - -"
    "d /persist/${name}/logs 700 101000 101000 - -"
  ];

  services.nginx.virtualHosts."${name}.averyan.ru" = {
    useACMEHost = "averyan.ru";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8000";
      proxyWebsockets = true;
    };
  };

  # Bambuddy's Virtual Printer services use fixed Bambu protocol ports. Limit
  # them to whale's trusted LAN and encrypted Nebula overlay instead of
  # exposing them on the WAN interface.
  networking.firewall.interfaces = {
    lan0 = virtualPrinterFirewall;
    "nebula.averyan" = virtualPrinterFirewall;
  };

  virtualisation.quadlet.containers.${name} = {
    containerConfig = {
      image = "ghcr.io/maziggy/bambuddy:latest";
      autoUpdate = "registry";
      memory = "4g";

      # Upstream recommends host networking on Linux for SSDP printer
      # discovery, camera streaming, and Virtual Printer protocol listeners.
      networks = [ "host" ];
      addCapabilities = [ "NET_BIND_SERVICE" ];

      volumes = [
        "/persist/${name}/data:/app/data"
        "/persist/${name}/logs:/app/logs"
      ];
      environments = {
        HOST = "127.0.0.1";
        PGID = "1000";
        PORT = "8000";
        PUID = "1000";
        TZ = "Europe/Moscow";
      };

      gidMaps = [ "0:100000:100000" ];
      uidMaps = [ "0:100000:100000" ];

      healthCmd = "curl --fail --silent http://127.0.0.1:8000/health";
      healthInterval = "30s";
      healthTimeout = "10s";
      healthRetries = 3;
      healthStartPeriod = "10s";
      healthOnFailure = "kill";
      notify = "healthy";
      stopTimeout = 30;
    };
    unitConfig = appUnitConfig;
    serviceConfig = appServiceConfig;
  };
}
