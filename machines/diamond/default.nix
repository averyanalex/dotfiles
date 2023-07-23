{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.roles.server
    ./hardware.nix
    ./mounts.nix
  ];

  system.stateVersion = "22.05";

  networking.interfaces.enp2s0.useDHCP = true;
}
