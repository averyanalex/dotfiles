{
  config,
  inputs,
  pkgs,
  ...
}: let
  infinitytgadminsbot-pkg = inputs.infinitytgadminsbot.packages.${pkgs.hostPlatform.system}.default;
in {
  age.secrets.kluckva.file = ../../secrets/creds/kluckva.age;

  systemd.services.kluckva = {
    after = ["network-online.target"];
    path = [infinitytgadminsbot-pkg];
    environment.RUST_LOG = "info";
    serviceConfig = {
      ExecStart = "${infinitytgadminsbot-pkg}/bin/infinitytgadminsbot";
      EnvironmentFile = config.age.secrets.kluckva.path;
      DynamicUser = true;
      User = "kluckva";
      Group = "kluckva";

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
