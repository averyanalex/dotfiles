{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
  };

  services.prometheus.exporters.postgres = {
    enable = true;
    runAsLocalSuperUser = true;
  };
  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [9187];

  persist.state.dirs = [
    {
      directory = "/var/lib/postgresql/14";
      user = "postgres";
      group = "postgres";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
