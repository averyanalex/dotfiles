{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.self.nixosModules.roles.desktop
    inputs.self.nixosModules.profiles.bluetooth
    inputs.self.nixosModules.profiles.netman
    inputs.self.nixosModules.profiles.openrgb
    ./hardware.nix
    ./mounts.nix
  ];

  # nixpkgs.localSystem = {
  #   gcc.arch = "znver3";
  #   gcc.tune = "znver3";
  #   system = "x86_64-linux";
  # };
  # nix.settings.system-features = [ "gccarch-znver3" ];

  system.stateVersion = "22.05";

  persist.tmpfsSize = "10G";

  networking = {
    firewall.allowedTCPPorts = [25565];

    # defaultGateway = {
    #   address = "192.168.3.1";
    #   interface = "enp10s0";
    # };

    # interfaces.enp10s0 = {
    #   ipv4 = {
    #     addresses = [{
    #       address = "192.168.3.60";
    #       prefixLength = 24;
    #     }];
    #   };
    # };
  };
}
