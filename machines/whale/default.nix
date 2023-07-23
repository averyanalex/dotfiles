{
  inputs,
  config,
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

    # inputs.self.nixosModules.profiles.libvirt
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

  # NETWORKING

  # Enable forwarding
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
      # gateway = ["95.165.96.1"];
      name = "${wan}";
      # routes = [
      #   {
      #     routeConfig = {
      #       Destination = "95.165.96.1";
      #       Source = "95.165.105.90";
      #     };
      #   }
      # ];
      networkConfig = {
        DHCP = "yes";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
      };
    };

    "40-${lan}" = {
      name = "${lan}";
      networkConfig = {
        IPv6AcceptRA = false;
        DHCPServer = true;
      };
      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 50;
        EmitDNS = true;
        DNS = "9.9.9.9";
      };
    };

    "40-yggbr" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
    };

    "40-wgav" = {
      # routes = [
      #   {
      #     routeConfig = {
      #       Destination = "::/0";
      #       Type = "unreachable";
      #       Table = 700;
      #     };
      #   }
      # ];
      # routingPolicyRules = [
      # {
      #   routingPolicyRuleConfig = {
      #     FirewallMark = 700;
      #     Table = 700;
      #   };
      # }
      # {
      #   routingPolicyRuleConfig = {
      #     User = "alex";
      #     Table = 700;
      #   };
      # }
      # ];
    };
    "40-wgavbr" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            IncomingInterface = "wgavbr";
            Table = 700;
          };
        }
      ];
    };
  };

  networking.firewall.allowedUDPPorts = [67 546];

  age.secrets.wg-key-averyan.file = ../../secrets/wireguard/whale.age;
  networking.wireguard.interfaces = {
    wgav = {
      allowedIPsAsRoutes = false;
      privateKeyFile = config.age.secrets.wg-key-averyan.path;
      peers = [
        {
          publicKey = "h+76esMcmPLakUN/1vDlvGGf2Ovmw/IDKKxFtqXCdm8=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "hawk.averyan.ru:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking = {
    nft-firewall = {
      extraFilterForwardRules = [
        ''iifname { "${lan}" } oifname "${wan}" counter accept comment "allow LAN to WAN"'' # vm0
        ''iifname "${wan}" oifname { "${lan}" } ct state { established, related } counter accept comment "allow established back to LAN"'' # vm0
        ''iifname "yggbr" oifname "ygg0" counter accept comment "allow YGGBR to YGG"''
        ''iifname "ygg0" oifname "yggbr" counter accept''
        ''iifname "wgavbr" oifname "wgav" counter accept''
        ''iifname "wgav" oifname "wgavbr" counter accept''
      ];
      extraNatPostroutingRules = [''oifname "${wan}" masquerade''];
      # extraMangleOutputRules = [''skuid 1000 counter mark set 701''];
    };

    bridges = {
      ${lan}.interfaces = ["${physLan}"];
      yggbr.interfaces = [];
      wgavbr.interfaces = [];
    };

    interfaces = {
      # "${wan}" = {
      #   ipv4 = {
      #     addresses = [
      #       {
      #         address = "95.165.105.90";
      #         prefixLength = 20;
      #       }
      #     ];
      #   };
      # };
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
      yggbr.ipv6.addresses = [
        {
          address = "30a:5fad::1";
          prefixLength = 64;
        }
      ];
      wgavbr = {
        ipv4 = {
          addresses = [
            {
              address = "10.8.8.1";
              prefixLength = 24;
            }
          ];
          routes = [
            {
              address = "10.8.8.0";
              prefixLength = 24;
              options.table = "700";
            }
          ];
        };
      };
      wgav = {
        ipv4 = {
          addresses = [
            {
              address = "10.8.8.2";
              prefixLength = 32;
            }
          ];
          routes = [
            {
              address = "10.8.7.0";
              prefixLength = 24;
            }
            {
              address = "10.8.7.0";
              prefixLength = 24;
              options.table = "700";
            }
            {
              address = "0.0.0.0";
              prefixLength = 0;
              via = "10.8.7.1";
              options.table = "700";
            }
          ];
        };
      };
    };
  };
}
