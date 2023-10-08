{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.hardware.ec2

    inputs.self.nixosModules.profiles.server.automm

    ./sync.nix
    ./influxdb.nix
  ];

  boot.kernel.sysctl = {
    "net.ipv4.tcp_low_latency" = 1;
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [9521];

  networking.interfaces.ens5.useDHCP = true;
  networking.nameservers = lib.mkForce [];
  system.stateVersion = "23.05";
}
