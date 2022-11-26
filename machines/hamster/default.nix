{ config, inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.roles.desktop
    inputs.self.nixosModules.profiles.netman
    inputs.self.nixosModules.profiles.bluetooth
    ./hardware.nix
    ./mounts.nix
  ];

  system.stateVersion = "22.05";
}
