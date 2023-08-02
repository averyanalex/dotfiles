{inputs, ...}: {
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.hardware.aeza

    inputs.self.nixosModules.profiles.remote-builder-client

    ./mounts.nix
  ];

  system.stateVersion = "23.05";

  networking = {
    defaultGateway = {
      address = "10.0.0.1";
      interface = "ens3";
    };

    interfaces = {
      ens3 = {
        ipv4 = {
          addresses = [
            {
              address = "5.42.84.150";
              prefixLength = 32;
            }
          ];
        };
      };
    };
  };
}
