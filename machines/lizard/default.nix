{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.roles.server

    inputs.self.nixosModules.profiles.server.hass
    inputs.self.nixosModules.profiles.server.pgsql

    inputs.self.nixosModules.profiles.netman
    inputs.self.nixosModules.profiles.podman

    inputs.self.nixosModules.hardware.rpi4

    ./mounts.nix
    ./hass.nix
    ./frigate.nix
  ];

  system.stateVersion = "23.05";
}
