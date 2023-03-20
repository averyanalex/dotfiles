{ config, inputs, ... }:
{
  age.secrets.cpmbot.file = ../../secrets/creds/cpmbot.age;

  systemd.services.cpmbot = {
    after = [ "network.target" ];
    path = [ inputs.cpmbot.packages.x86_64-linux.default ];
    serviceConfig = {
      User = "cpmbot";
      Group = "cpmbot";
      EnvironmentFile = config.age.secrets.cpmbot.path;
      ExecStart = "${inputs.cpmbot.packages.x86_64-linux.default}/bin/cpmbot";
      PrivateTmp = "true";
      PrivateDevices = "true";
      ProtectHome = "true";
      ProtectSystem = "strict";
      WorkingDirectory = "/var/lib/cpmbot";
      StateDirectory = "cpmbot";
      StateDirectoryMode = "0700";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  persist.state.dirs = [{ directory = "/var/lib/cpmbot"; user = "cpmbot"; group = "cpmbot"; mode = "u=rwx,g=,o="; }];

  users = {
    users.cpmbot = {
      uid = 994;
      isSystemUser = true;
      description = "CPM Bot";
      home = "/var/lib/cpmbot";
      createHome = true;
      group = "cpmbot";
    };

    groups.cpmbot.gid = 990;
  };
}
