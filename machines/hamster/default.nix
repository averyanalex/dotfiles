{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.self.nixosModules.roles.desktop

    inputs.self.nixosModules.profiles.bluetooth
    inputs.self.nixosModules.profiles.netman
    # inputs.self.nixosModules.profiles.remote-builder-client

    inputs.self.nixosModules.hardware.thinkbook

    ./mounts.nix
  ];

  services.tlp = {
    enable = true;
    settings = {
      STOP_CHARGE_THRESH_BAT0 = 1;
      # START_CHARGE_THRESH_BAT0 = 50;
      # STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';
  # TODO: setup suspend-then-hibernate after systemd regression will be fixed
  # HandleLidSwitch=suspend-then-hibernate

  # systemd.sleep.extraConfig = ''
  #   HibernateDelaySec=120s
  #   SuspendEstimationSec=60s
  # '';

  system.stateVersion = "22.05";
}
