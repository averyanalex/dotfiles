let
  name = "hass";
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
  systemd.slices.${sliceName}.description = "Home Assistant application services";

  systemd.tmpfiles.rules = [
    "d /data/${name}/config 700 0 0 - -"
  ];

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [ 8123 ];

  virtualisation.quadlet = {
    containers = {
      "${name}" = {
        containerConfig = {
          image = "ghcr.io/home-assistant/home-assistant:stable";
          autoUpdate = "registry";
          networks = [ "host" ];
          podmanArgs = [ "--privileged" ];
          volumes = [
            "/data/${name}/config:/config"
            "/run/dbus:/run/dbus:ro"
            "/dev:/dev"
          ];
          environments = {
            TZ = "Europe/Moscow";
          };
        };
        unitConfig = appUnitConfig;
        serviceConfig = appServiceConfig;
      };
    };
  };
}
