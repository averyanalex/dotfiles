{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.profiles.netman
    inputs.self.nixosModules.hardware.rpi4

    ./mounts.nix
  ];

  system.stateVersion = "22.11";

  networking = {
    hostName = "lizard";
  };
}
