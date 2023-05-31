{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.profiles.netman
    inputs.self.nixosModules.hardware.rpi4

    ./mounts.nix
  ];

  system.stateVersion = "23.05";

  networking = {
    hostName = "lizard";
  };
}
