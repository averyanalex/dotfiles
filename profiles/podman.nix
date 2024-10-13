{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    extraPackages = with pkgs; [
      slirp4netns
    ];
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers.backend = "podman";
  # virtualisation.containers.containersConf.settings.network.network_backend = lib.mkForce "cni"; # nftables workaround

  persist.state.homeDirs = [
    {
      directory = ".local/share/containers";
      mode = "u=rwx,g=,o=";
    }
  ];
  persist.state.dirs = [
    {
      directory = "/root/.local/share/containers";
      mode = "u=rwx,g=,o=";
    }
    {
      directory = "/var/lib/containers";
      mode = "u=rwx,g=rx,o=rx";
    }
  ];
}
