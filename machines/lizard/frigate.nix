let
  name = "frigate";
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
  systemd.slices.${sliceName}.description = "Frigate application services";

  systemd.tmpfiles.rules = [
    "d /data/${name}/config 700 0 0 - -"
    "d /data/${name}/media 700 0 0 - -"
  ];

  networking.nftables.tables.portforward-nat = {
    family = "inet";
    content = ''
      chain pre {
        type nat hook prerouting priority dstnat; policy accept;
        iifname nebula.averyan ip daddr 10.57.1.30 tcp dport 8971 dnat to 10.90.246.2:8971
      }
    '';
  };

  networking.firewall.interfaces."pme-frigate".allowedTCPPorts = [ 1883 ]; # mqtt

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      containers = {
        "${name}" = {
          containerConfig = {
            image = "ghcr.io/blakeblackshear/frigate:stable";
            autoUpdate = "registry";
            networks = [ networks.${name}.ref ];
            ip = "10.90.246.2";
            podmanArgs = [
              # runsc does not support generic V4L2 device passthrough.
              "--runtime=crun"
              "--privileged"
            ];
            volumes = [
              "/etc/localtime:/etc/localtime:ro"
              "/data/${name}/config:/config"
              "/data/${name}/media:/media/frigate"
            ];
            mounts = [
              "type=tmpfs,tmpfs-size=1024M,destination=/tmp/cache"
            ];
            devices = [
              "/dev/video11:/dev/video11"
            ];
            shmSize = "512m";
          };
          unitConfig = appUnitConfig;
          serviceConfig = appServiceConfig;
        };
      };

      networks = {
        ${name} = {
          networkConfig = {
            subnets = [ "10.90.246.0/24" ];
            podmanArgs = [ "--interface-name=pme-${name}" ];
          };
          serviceConfig.Slice = appServiceConfig.Slice;
        };
      };
    };
}
