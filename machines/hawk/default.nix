{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.hardware.aeza
    ./mounts.nix
  ];

  system.stateVersion = "22.05";

  networking = {
    defaultGateway = {
      address = "10.0.0.1";
      interface = "ens3";
    };

    interfaces = {
      ens3 = {
        ipv4 = {
          addresses = [{
            address = "185.112.83.99";
            prefixLength = 32;
          }];
        };
      };
    };
  };
}
