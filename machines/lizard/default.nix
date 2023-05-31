{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.roles.server

    inputs.self.nixosModules.profiles.server.hass
    inputs.self.nixosModules.profiles.server.pgsql

    inputs.self.nixosModules.profiles.netman

    inputs.self.nixosModules.hardware.rpi4

    ./mounts.nix
    ./hass.nix
  ];

  system.stateVersion = "23.05";

  networking = {
    hostName = "lizard";
  };
}
