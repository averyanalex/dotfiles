{ inputs, config, ... }:

{
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.hardware.aeza
    ./mounts.nix

    inputs.self.nixosModules.profiles.server.acme
    inputs.self.nixosModules.profiles.server.blog
    inputs.self.nixosModules.profiles.server.mail
    inputs.self.nixosModules.profiles.server.nginx
  ];

  system.stateVersion = "22.05";

  age.secrets.wg-key.file = ../../secrets/wireguard/hawk.age;

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;

    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;

    "net.ipv6.conf.all.forwarding" = false;
    "net.ipv6.conf.default.forwarding" = false;
  };

  networking = {
    defaultGateway = {
      address = "10.0.0.1";
      interface = "ens3";
    };

    nft-firewall = {
      extraFilterForwardRules = [
        "iifname wg0 oifname ens3 counter accept"
        "iifname ens3 oifname wg0 ct state { established, related } counter accept"
      ];
      extraNatPostroutingRules = [ "oifname ens3 masquerade" ];
    };

    firewall.allowedUDPPorts = [ 51820 ];

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.8.7.1/24" ];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wg-key.path;
        peers = [
          {
            # POCOFT
            publicKey = "9vFNcLY6iWyHToTduhYD5m5Kj7v4RfERqC0pIWphsgU=";
            allowedIPs = [ "10.8.7.2/32" ];
          }
        ];
      };
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
