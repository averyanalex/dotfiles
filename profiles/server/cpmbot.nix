{
  config,
  inputs,
  pkgs,
  ...
}: let
  cpmbot-pkg = inputs.cpmbot.packages.${pkgs.hostPlatform.system}.default;
in {
  age.secrets.cpmbot.file = ../../secrets/creds/cpmbot.age;

  systemd.services.cpmbot = {
    after = ["network.target"];
    path = [cpmbot-pkg];
    environment = {
      RUST_LOG = "debug";
      DATABASE_URL = "postgresql:///cpmbot";
    };
    serviceConfig = {
      User = "cpmbot";
      Group = "cpmbot";
      EnvironmentFile = config.age.secrets.cpmbot.path;
      ExecStart = "${cpmbot-pkg}/bin/cpmbot";
      PrivateTmp = "true";
      PrivateDevices = "true";
      ProtectHome = "true";
      ProtectSystem = "strict";
      Restart = "always";
    };
    wantedBy = ["multi-user.target"];
  };

  services.postgresql = {
    ensureDatabases = ["cpmbot"];
    ensureUsers = [
      {
        name = "cpmbot";
        ensurePermissions = {
          "DATABASE cpmbot" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  users = {
    users.cpmbot = {
      isSystemUser = true;
      description = "CPM Bot";
      group = "cpmbot";
    };
    groups.cpmbot = {};
  };
}
