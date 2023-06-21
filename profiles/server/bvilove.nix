{
  config,
  inputs,
  pkgs,
  ...
}: let
  bvilovebot-pkg = inputs.bvilovebot.packages.${pkgs.hostPlatform.system}.default;
in {
  age.secrets.bvilove.file = ../../secrets/creds/bvilove.age;

  systemd.services.bvilovebot = {
    after = ["network-online.target" "postgresql.service"];
    requires = ["postgresql.service"];
    path = [bvilovebot-pkg];
    environment = {
      DATABASE_URL = "postgresql:///bvilove";
    };
    serviceConfig = {
      User = "bvilove";
      Group = "bvilove";
      EnvironmentFile = config.age.secrets.bvilove.path;
      ExecStart = "${bvilovebot-pkg}/bin/bvilovebot";
      Restart = "always";

      # Capabilities
      CapabilityBoundingSet = "";
      # Security
      NoNewPrivileges = true;
      # Sandboxing
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      PrivateDevices = true;
      PrivateUsers = true;
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = ["AF_UNIX AF_INET AF_INET6"];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      PrivateMounts = true;
    };
    wantedBy = ["multi-user.target"];
  };

  services.postgresql = {
    ensureDatabases = ["bvilove"];
    ensureUsers = [
      {
        name = "bvilove";
        ensurePermissions = {
          "DATABASE bvilove" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  users = {
    users.bvilove = {
      isSystemUser = true;
      description = "BVI Love";
      group = "bvilove";
    };
    groups.bvilove = {};
  };
}
