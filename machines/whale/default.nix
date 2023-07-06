{
  inputs,
  # config,
  ...
}: let
  wan = "enp6s0";
  physLan = "enp5s0";
  lan = "lan0";
in {
  imports = [
    inputs.self.nixosModules.roles.server

    # inputs.self.nixosModules.profiles.server.qbit
    # inputs.self.nixosModules.profiles.server.cpmbot
    inputs.self.nixosModules.profiles.server.bvilove
    inputs.self.nixosModules.profiles.server.gitea
    inputs.self.nixosModules.profiles.server.hass
    inputs.self.nixosModules.profiles.server.hydra
    inputs.self.nixosModules.profiles.server.kluckva
    inputs.self.nixosModules.profiles.server.mqtt
    inputs.self.nixosModules.profiles.server.mysql
    inputs.self.nixosModules.profiles.server.pgsql
    inputs.self.nixosModules.profiles.server.radicale
    inputs.self.nixosModules.profiles.server.vaultwarden

    inputs.self.nixosModules.profiles.libvirt
    inputs.self.nixosModules.profiles.networkd
    inputs.self.nixosModules.profiles.persist-yggdrasil
    inputs.self.nixosModules.profiles.podman
    inputs.self.nixosModules.profiles.remote-builder-host
    inputs.self.nixosModules.profiles.sync

    ./hardware.nix
    ./mounts.nix

    # ./firesquare.nix
    ./hass.nix
    ./monitoring.nix
    ./photoprism.nix
    ./pterodactyl.nix
    ./tanksrv.nix
    ./yacy.nix
  ];

  system.stateVersion = "22.05";

  # RAM
  hardware.ksm.enable = true;
  persist.tmpfsSize = "16G";

  services.kubo.dataDir = "/hdd/ipfs";
  services.syncthing.dataDir = "/tank/sync";

  # Monitoring
  services.prometheus.exporters.node.enabledCollectors = ["zoneinfo"];

  # Networking
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
  };

  systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

  systemd.network.networks = {
    "40-${wan}" = {
      name = "${wan}";
      networkConfig = {
        LinkLocalAddressing = "ipv6";
        IPv6AcceptRA = true;
        DHCP = "yes";
      };
      ipv6AcceptRAConfig = {
        DHCPv6Client = "always";
        UseAutonomousPrefix = false;
      };
    };

    "40-${lan}" = {
      name = "${lan}";
      networkConfig = {
        IPv6AcceptRA = false;
        IPv6SendRA = true;
        DHCPPrefixDelegation = true;

        DHCPServer = true;
      };
      dhcpPrefixDelegationConfig.UplinkInterface = "${wan}";
      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 50;
        EmitDNS = true;
        DNS = "9.9.9.9";
      };
    };

    "40-vm0" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 100;
        DNS = "9.9.9.9";
      };
    };

    "40-yggbr0" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
    };
  };

  networking.firewall.allowedUDPPorts = [67 546];

  # age.secrets.wg-key-frsqr.file = ../../secrets/wireguard/whale-frsqr.age;
  # networking.wireguard.interfaces = {
  #   wg-frsqr = {
  #     ips = ["10.100.0.4/32"];
  #     privateKeyFile = config.age.secrets.wg-key-frsqr.path;
  #     peers = [
  #       {
  #         publicKey = "k8XDvqLf9eZzVkY0NpAU3TXgisDAsOOtg+wImiootA8=";
  #         allowedIPs = ["10.100.0.0/24"];
  #         endpoint = "rat.frsqr.xyz:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  networking = {
    nft-firewall = {
      extraFilterForwardRules = [
        ''iifname { "${lan}", "vm0" } oifname "${wan}" counter accept comment "allow LAN to WAN"''
        ''iifname "${wan}" oifname { "${lan}", "vm0" } ct state { established, related } counter accept comment "allow established back to LAN"''
        ''iifname "yggbr0" oifname "ygg0" counter accept comment "allow YGGBR to YGG"''
        ''iifname "ygg0" oifname "yggbr0" counter accept''
        # ''iifname "ygg0" oifname "yggbr0" ct state { established, related } counter accept comment "allow established back to YGGBR0"''
      ];
      extraNatPostroutingRules = [''oifname "${wan}" masquerade''];
    };

    bridges = {
      ${lan}.interfaces = ["${physLan}"];
      vm0.interfaces = [];
      yggbr0.interfaces = [];
    };

    interfaces = {
      "${lan}" = {
        ipv4 = {
          addresses = [
            {
              address = "192.168.3.1";
              prefixLength = 24;
            }
          ];
        };
      };
      vm0 = {
        ipv4 = {
          addresses = [
            {
              address = "192.168.12.1";
              prefixLength = 24;
            }
          ];
        };
      };
      yggbr0.ipv6.addresses = [
        {
          address = "317:7b20:ee43:21d3::1";
          prefixLength = 64;
        }
      ];
    };
  };
}
