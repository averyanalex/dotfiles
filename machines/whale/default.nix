{ inputs, config, ... }:
let
  wan = "enp6s0";
  physLan = "enp5s0";
  lan = "lan0";
in
{
  imports = [
    inputs.self.nixosModules.roles.server

    inputs.self.nixosModules.profiles.server.firesquare
    inputs.self.nixosModules.profiles.server.mysql
    inputs.self.nixosModules.profiles.server.pgsql
    inputs.self.nixosModules.profiles.server.photoprism
    inputs.self.nixosModules.profiles.server.pterodactyl
    inputs.self.nixosModules.profiles.server.qbit

    inputs.self.nixosModules.profiles.libvirt
    inputs.self.nixosModules.profiles.tanksrv
    ./hardware.nix
    ./mounts.nix
  ];

  system.stateVersion = "22.05";

  # RAM
  hardware.ksm.enable = true;
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  services.kubo.dataDir = "/hdd/ipfs";

  # Monitoring
  services.prometheus.exporters.node.enabledCollectors = [ "zoneinfo" ];

  # Networking
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;

    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;

    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "${lan}" "vm0" ];
    extraConfig = ''
      option domain-name-servers 8.8.8.8, 1.1.1.1;
      option subnet-mask 255.255.255.0;
      subnet 192.168.3.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.3.255;
        option routers 192.168.3.1;
        interface ${lan};
        range 192.168.3.100 192.168.3.199;
      }
      subnet 192.168.12.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.12.255;
        option routers 192.168.12.1;
        interface vm0;
        range 192.168.12.100 192.168.12.199;
      }
    '';
  };

  age.secrets.wg-key-frsqr.file = ../../secrets/wireguard/whale-frsqr.age;
  networking.wireguard.interfaces = {
    wg-frsqr = {
      ips = [ "10.100.0.4/32" ];
      privateKeyFile = config.age.secrets.wg-key-frsqr.path;
      peers = [
        {
          publicKey = "k8XDvqLf9eZzVkY0NpAU3TXgisDAsOOtg+wImiootA8=";
          allowedIPs = [ "10.100.0.0/24" ];
          endpoint = "rat.frsqr.xyz:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking = {
    hostName = "whale";

    nft-firewall = {
      extraFilterForwardRules = [
        ''iifname { "${lan}", "vm0" } oifname "${wan}" counter accept comment "allow LAN to WAN"''
        ''iifname "${wan}" oifname { "${lan}", "vm0" } ct state { established, related } counter accept comment "allow established back to LAN"''
      ];
      extraNatPostroutingRules = [ ''oifname "${wan}" masquerade'' ];
    };

    bridges = {
      ${lan}.interfaces = [ "${physLan}" ];
      vm0.interfaces = [ ];
    };

    interfaces = {
      "${lan}" = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.1";
            prefixLength = 24;
          }];
        };
      };
      vm0 = {
        ipv4 = {
          addresses = [{
            address = "192.168.12.1";
            prefixLength = 24;
          }];
        };
      };
      "${wan}".useDHCP = true;
    };
  };
}
