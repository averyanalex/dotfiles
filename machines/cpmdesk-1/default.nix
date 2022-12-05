{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.roles.cpmdesk
    ./hardware.nix
    ./mounts.nix
  ];

  system.stateVersion = "22.11";

  networking.interfaces.enp0s31f6.useDHCP = true;
}
