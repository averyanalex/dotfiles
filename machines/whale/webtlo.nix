{
  config,
  ...
}:
let
  name = "webtlo";
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
  systemd.slices.${sliceName}.description = "WebTLO application services";

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks;
    in
    {
      containers = {
        webtlo = {
          containerConfig = {
            image = "docker.io/berkut174/webtlo:latest";
            autoUpdate = "registry";
            memory = "512m";
            volumes = [ "/var/lib/webtlo:/data" ];
            networks = [ networks.webtlo.ref ];
            ip = "10.90.26.2";
            gidMaps = [ "0:100000:100000" ];
            uidMaps = [ "0:100000:100000" ];
          };
          unitConfig = appUnitConfig;
          serviceConfig = appServiceConfig;
        };
      };
      networks = {
        webtlo = {
          networkConfig = {
            subnets = [ "10.90.26.0/24" ];
            podmanArgs = [ "--interface-name=pme-webtlo" ];
          };
          serviceConfig.Slice = appServiceConfig.Slice;
        };
      };
    };

  networking.firewall.interfaces.pme-webtlo.allowedTCPPorts = [
    8080 # http proxy
  ];

  networking.firewall.extraForwardRules = ''
    iifname pme-webtlo oifname pme-qbit accept
  '';

  # access with ssh -L 1844:10.90.26.2:80 whale

  persist.state.dirs = [
    {
      directory = "/var/lib/webtlo";
      user = "101000";
      group = "101000";
      mode = "u=rwx,g=,o=";
    }
  ];
}
