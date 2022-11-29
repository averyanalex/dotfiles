{ pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
  };

  persist.state.dirs = [{ directory = "/var/lib/postgresql/14"; user = "postgres"; group = "postgres"; mode = "u=rwx,g=rx,o="; }];
}
