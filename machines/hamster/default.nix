{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.self.nixosModules.profiles.bluetooth
    inputs.self.nixosModules.profiles.netman
    inputs.self.nixosModules.profiles.remote-builder-client
    inputs.self.nixosModules.roles.desktop
    ./hardware.nix
    ./mounts.nix
  ];

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
