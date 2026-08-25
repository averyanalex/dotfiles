let
  name = "ollama";
  port = 11434;
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
  systemd.slices.${sliceName}.description = "Ollama application services";

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [ port ];

  systemd.tmpfiles.rules = [
    "d /var/lib/${name} 700 100999 100999 - -"
  ];

  virtualisation.quadlet = {
    containers.${name} = {
      containerConfig = {
        image = "docker.io/ollama/ollama:rocm";
        autoUpdate = "registry";
        networks = [ "host" ];
        # gVisor's GPU proxy supports NVIDIA, not AMD ROCm devices.
        podmanArgs = [ "--runtime=crun" ];
        devices = [
          "/dev/kfd"
          "/dev/dri"
        ];
        volumes = [ "/var/lib/${name}:/root/.ollama" ];
        gidMaps = [ "0:100000:100000" ];
        uidMaps = [ "0:100000:100000" ];
      };
      unitConfig = appUnitConfig;
      serviceConfig = appServiceConfig // {
        MemoryMax = "24G";
      };
    };
  };
}
