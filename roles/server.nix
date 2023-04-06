{inputs, ...}: {
  imports =
    [
      ./base.nix
    ]
    ++ (with inputs.self.nixosModules.modules; [
      ])
    ++ (with inputs.self.nixosModules.profiles; [
      ]);

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
