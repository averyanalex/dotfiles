{
  config,
  inputs,
  pkgs,
  ...
}: let
  automm-pkg = inputs.automm.packages.${pkgs.hostPlatform.system}.default.overrideAttrs (final: prev: {
    RUSTFLAGS = "-Ctarget-cpu=neoverse-v1";
  });
in {
  age.secrets.automm.file = ../../secrets/creds/automm.age;
  systemd.services.automm = {
    after = ["network-online.target"];
    path = [automm-pkg];
    environment.RUST_LOG = "info";
    environment.SYMBOLS_TABLE = "${automm-pkg}/share/symbols.csv";
    serviceConfig = {
      EnvironmentFile = config.age.secrets.automm.path;
      User = "automm";
      Group = "automm";

      ExecStart = "${automm-pkg}/bin/automm";
      DynamicUser = true;

      CPUSchedulingPolicy = "rr";
      CPUSchedulingPriority = 80;
      IOSchedulingPriority = 1;

      Restart = "on-failure";
      RestartSec = "5s";

      # Hardening
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      DevicePolicy = "closed";
      NoNewPrivileges = true; # Implied by DynamicUser
      PrivateUsers = true;
      PrivateTmp = true; # Implied by DynamicUser
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      ProtectSystem = "strict";
      RemoveIPC = true; # Implied by DynamicUser
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true; # Implied by DynamicUser
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
      ];
      UMask = "0077";
    };
    wantedBy = ["multi-user.target"];
  };
}
