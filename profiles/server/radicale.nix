{ config, ... }:
{
  age.secrets.radicale-password.file = ../../secrets/accounts/radicale.age;
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "10.5.3.20:5232" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets.radicale-password.path;
        htpasswd_encryption = "bcrypt";
      };
    };
  };
  persist.state.dirs = [{ directory = "/var/lib/radicale/collections"; user = "radicale"; group = "radicale"; mode = "u=rwx,g=rx,o="; }];
}
