{
  config,
  inputs,
  pkgs,
  ...
}: let
  memexpert-pkg = inputs.memexpert.packages.${pkgs.hostPlatform.system}.default;
in {
  age.secrets.memexpert.file = ../../secrets/creds/memexpert.age;

  systemd.services.memexpert = {
    after = ["network-online.target" "postgresql.service"];
    wants = ["network-online.target"];
    requires = ["postgresql.service"];
    path = [memexpert-pkg];
    environment = {
      DATABASE_URL = "postgresql:///memexpert";
    };
    serviceConfig = {
      User = "memexpert";
      Group = "memexpert";
      EnvironmentFile = config.age.secrets.memexpert.path;
      ExecStart = "${memexpert-pkg}/bin/memexpert";
      Restart = "on-failure";

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
    ensureDatabases = ["memexpert"];
    ensureUsers = [
      {
        name = "memexpert";
        ensureDBOwnership = true;
      }
    ];
  };

  users = {
    users.memexpert = {
      isSystemUser = true;
      description = "MemeXpert";
      group = "memexpert";
    };
    groups.memexpert = {};
  };
}
