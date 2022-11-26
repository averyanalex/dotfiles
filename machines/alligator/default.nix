{ config, inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.roles.desktop
    inputs.self.nixosModules.profiles.openrgb
    ./hardware.nix
    ./mounts.nix
  ];

  system.stateVersion = "22.05";

  networking = {
    firewall.enable = false;

    defaultGateway = {
      address = "192.168.3.1";
      interface = "enp10s0";
    };

    interfaces.enp10s0 = {
      ipv4 = {
        addresses = [{
          address = "192.168.3.60";
          prefixLength = 24;
        }];
      };
    };
  };
}
