{
  nix = {
    settings = {
      auto-optimise-store = true;

      keep-outputs = true;
      keep-derivations = true;

      allowed-users = ["root" "@users"];
      trusted-users = ["root" "@wheel"];

      builders-use-substitutes = true;
      connect-timeout = 5;

      log-lines = 25;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      dates = "04:15";
      randomizedDelaySec = "1800";
      options = "--delete-older-than 7d";
    };

    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
    daemonCPUSchedPolicy = "batch";
  };
}
