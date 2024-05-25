{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers.backend = "podman";
  # virtualisation.containers.containersConf.settings.network.network_backend = lib.mkForce "cni"; # nftables workaround

  home-manager.users.alex = {
    home.packages = [
      pkgs.x11docker
    ];
  };

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
