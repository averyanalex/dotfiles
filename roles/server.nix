{inputs, ...}: {
  imports = [
    ./base.nix
  ];

  systemd = {
    enableEmergencyMode = false;

    watchdog = {
      runtimeTime = "30s";
      rebootTime = "10m";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };
}
