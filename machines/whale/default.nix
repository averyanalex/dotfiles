{
  inputs,
  config,
  ...
}: let
  wan = "enp5s0"; # with gpu: enp6s0
  physLan = "enp4s0"; # with gpu: enp5s0
  lan = "lan0";

  makeHost = proxyPass: {
    locations."/".proxyPass = proxyPass;
    locations."/".proxyWebsockets = true;
  };

  makeAveryanHost = proxyPass: makeHost proxyPass // {useACMEHost = "averyan.ru";};
in {
  imports = [
    inputs.self.nixosModules.roles.server

    inputs.self.nixosModules.profiles.server.qbit
    # inputs.self.nixosModules.profiles.server.cpmbot
    inputs.self.nixosModules.profiles.server.gayradar
    inputs.self.nixosModules.profiles.server.anoquebot
    inputs.self.nixosModules.profiles.server.picsav
    inputs.self.nixosModules.profiles.server.acme
    inputs.self.nixosModules.profiles.server.blog
    # inputs.self.nixosModules.profiles.server.bvilove
    # inputs.self.nixosModules.profiles.server.gitea
    inputs.self.nixosModules.profiles.server.hass
    # inputs.self.nixosModules.profiles.server.hydra
    inputs.self.nixosModules.profiles.server.kluckva
    # inputs.self.nixosModules.profiles.server.mqtt
    inputs.self.nixosModules.profiles.server.mysql
    inputs.self.nixosModules.profiles.server.nginx
    inputs.self.nixosModules.profiles.server.ntfy-sh
    inputs.self.nixosModules.profiles.server.pgsql
    inputs.self.nixosModules.profiles.server.radicale
    inputs.self.nixosModules.profiles.server.forgejo
    inputs.self.nixosModules.profiles.server.searx
    inputs.self.nixosModules.profiles.server.vaultwarden
    inputs.self.nixosModules.profiles.server.matomo
    inputs.self.nixosModules.profiles.server.qdrant
    inputs.self.nixosModules.profiles.server.meilisearch
    inputs.self.nixosModules.profiles.server.memexpert
    # inputs.self.nixosModules.profiles.server.aibox

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
    ./tor.nix
    ./i2p.nix
    ./lidarr.nix
    ./ups.nix
    # ./ipfs.nix
    ./mail.nix
    ./matrix.nix
    ./cosmovert.nix
    ./webtlo.nix
    ./dns.nix
    ./borgserve.nix
  ];

  system.stateVersion = "22.05";

  # RAM
  hardware.ksm.enable = true;
  persist.tmpfsSize = "16G";

  services.syncthing.dataDir = "/home/alex/tank/hot/sync";

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

  services.nginx.virtualHosts = {
    "bw.averyan.ru" = makeAveryanHost "http://whale:8222";
    "dacha.averyan.ru" = makeAveryanHost "http://lizard:8123";
    "dav.averyan.ru" = makeAveryanHost "http://whale:5232";
    "git.averyan.ru" = makeAveryanHost "http://whale:3816";
    "grafana.averyan.ru" = makeAveryanHost "http://whale:3729";
    "home.averyan.ru" = makeAveryanHost "http://whale:8123";
    "hydra.averyan.ru" = makeAveryanHost "http://whale:2875";
    "ntfy.averyan.ru" = makeAveryanHost "http://127.0.0.1:8163";
    "olsearch.averyan.ru" = makeAveryanHost "http://whale:8739";
    "prism.averyan.ru" = makeAveryanHost "http://whale:2342";
    "search.averyan.ru" = makeAveryanHost "http://127.0.0.1:8278";
    "lidarr.averyan.ru" = makeAveryanHost "http://127.0.0.1:8686";
    "yacy.averyan.ru" = makeAveryanHost "http://whale:8627";
    "lab.averyan.ru" = makeAveryanHost "http://127.0.0.1:8874";
    "memexpert.xyz" = makeHost "http://127.0.0.1:3000" // {useACMEHost = "memexpert.xyz";};

    "git.neutrino.su" = makeHost "http://whale:3826" // {useACMEHost = "neutrino.su";};
    "bw.neutrino.su" = makeHost "http://whale:8222" // {useACMEHost = "neutrino.su";};

    "ptero.averyan.ru" = makeAveryanHost "http://192.168.12.50:80";
    "whale-ptero.averyan.ru" = makeAveryanHost "http://192.168.12.50:443";
    "diamond-ptero.averyan.ru" = makeAveryanHost "http://diamond:443";
  };

  networking.nebula-averyan.isLighthouse = true;

  systemd.network.networks = {
    "40-${wan}" = {
      # gateway = ["95.165.96.1"];
      name = "${wan}";
      # routes = [
      #   {
      #     routeConfig =
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

    "40-vms" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
        DHCPServer = true;
      };
      dhcpServerConfig = {
        PoolOffset = 100;
        PoolSize = 50;
        EmitDNS = true;
        DNS = "192.168.3.1";
      };
    };

    "40-yggbr" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      linkConfig.RequiredForOnline = false;
    };

    "40-wgav" = {
      routes = [
        {
          Destination = "::/0";
          Type = "unreachable";
          Table = 700;
        }
      ];
      routingPolicyRules = [
        {
          FirewallMark = 700;
          Table = 700;
        }
        # {
        #   routingPolicyRuleConfig = {
        #     User = "alex";
        #     Table = 700;
        #   };
        # }
      ];
    };
    "40-wgavbr" = {
      networkConfig = {
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      linkConfig.RequiredForOnline = false;
      routingPolicyRules = [
        {
          IncomingInterface = "wgavbr";
          Table = 700;
        }
      ];
    };
  };

  networking.firewall = {
    interfaces.${lan}.allowedTCPPorts = [22];
    allowedUDPPorts = [67 546]; # DHCP
  };

  age.secrets.wg-key-averyan.file = ../../secrets/wireguard/whale.age;
  networking.wireguard.interfaces = {
    wgav = {
      allowedIPsAsRoutes = false;
      privateKeyFile = config.age.secrets.wg-key-averyan.path;
      peers = [
        {
          publicKey = "h+76esMcmPLakUN/1vDlvGGf2Ovmw/IDKKxFtqXCdm8=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "vpn.averyan.ru:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.yggdrasil.settings = {
    Peers = [
      "tcp://yggdrasil.community.garage.networks.deavmi.assigned.network:2000"
      "tcp://sin.yuetau.net:6642"
      "tcp://195.123.245.146:7743"
      "tls://37.205.14.171:993"
      "tls://fi1.servers.devices.cwinfo.net:61995"
      "tls://aurora.devices.waren.io:18836"
      "tls://fr2.servers.devices.cwinfo.net:23108"
      "tcp://51.15.204.214:12345"
      "tls://cloudberry.fr1.servers.devices.cwinfo.net:54232"
      "tcp://s2.i2pd.xyz:39565"
      "tcp://94.130.203.208:5999"
      "tcp://ygg.mkg20001.io:80"
      "tcp://phrl42.ydns.eu:8842"
      "tcp://gutsche.tech:8888"
      "tcp://ygg1.mk16.de:1337"
      "tcp://ygg2.mk16.de:1337"
      "tls://vpn.ltha.de:443"
      "tls://de-fsn-1.peer.v4.yggdrasil.chaz6.com:4444"
      "tcp://yggdrasil.su:62486"
      "tls://x-fra-0.sergeysedoy97.ru:65535"
      "tcp://193.107.20.230:7743"
      "tcp://ygg.yt:80"
      "tls://94.140.114.241:4708"
      "tls://94.103.82.150:8080"
      "tcp://vpn.itrus.su:7991"
      "tls://45.147.198.155:6010"
      "tls://23.137.249.65:443"
      "tls://23.137.251.45:5222"
      "tls://x-ams-0.sergeysedoy97.ru:65535"
      "tls://x-ams-1.sergeysedoy97.ru:65535"
      "tls://pl1.servers.devices.cwinfo.net:11129"
      "tcp://185.165.169.234:8880"
      "tcp://yggno.de:18226"
      "tls://x-mow-0.sergeysedoy97.ru:65535"
      "tls://x-mow-1.sergeysedoy97.ru:65535"
      "tls://x-mow-2.sergeysedoy97.ru:65535"
      "tls://x-mow-3.sergeysedoy97.ru:65535"
      "tls://x-mow-4.sergeysedoy97.ru:65535"
      "tcp://45.147.200.202:12402"
      "tcp://45.95.202.21:12403"
      "tcp://box.paulll.cc:13337"
      "tls://x-led-0.sergeysedoy97.ru:65535"
      "tls://avevad.com:1337"
      "tcp://srv.itrus.su:7991"
      "tcp://antebeot.ru:7890"
      "tls://x-ovb-0.sergeysedoy97.ru:65535"
      "tls://x-ovb-1.sergeysedoy97.ru:65535"
      "tcp://itcom.multed.com:7991"
      "tcp://ekb.itrus.su:7991"
      "tls://x-kzn-0.sergeysedoy97.ru:65535"
      "tcp://y.zbin.eu:7743"
      "tls://185.130.44.194:7040"
      "tcp://ygg.ace.ctrl-c.liu.se:9998"
      "tcp://zhoskiy.xyz:30111"
      "tls://x-sto-0.sergeysedoy97.ru:65535"
      "tcp://193.111.114.28:8080"
      "tcp://78.27.153.163:33165"
      "tcp://158.101.229.219:17002"
      "tls://ca1.servers.devices.cwinfo.net:58226"
      "tcp://kusoneko.moe:9002"
      "tcp://supergay.network:9002"
      "tls://108.175.10.127:61216"
      "tls://102.223.180.74:993"
      "tcp://lancis.iscute.moe:49273"
      "tcp://longseason.1200bps.xyz:13121"
      "tls://44.234.134.124:443"
      "tcp://ygg3.mk16.de:1337"
      "tls://ygg.mnpnk.com:443"
      "tcp://cowboy.supergay.network:9111"
      "tls://ygg.jjolly.dev:3443"
      "tls://167.160.89.98:7040"
      "tcp://zabugor.itrus.su:7991"
    ];
    NodeInfo.public = {
      internet = ["tls://ygg-msk-1.averyan.ru:8362" "tcp://ygg-msk-1.averyan.ru:8363"];
    };
  };

  networking = {
    nft-firewall = {
      extraFilterForwardRules = [
        ''iifname { "${lan}", "vms" } oifname "${wan}" counter accept comment "allow LAN to WAN"''
        ''iifname "${wan}" oifname { "${lan}", "vms" } ct state { established, related } counter accept comment "allow established back to LAN"''
        ''iifname "yggbr" oifname "ygg0" counter accept comment "allow YGGBR to YGG"''
        ''iifname "ygg0" oifname "yggbr" counter accept''
        ''iifname "wgavbr" oifname "wgav" counter accept''
        ''iifname "wgav" oifname "wgavbr" counter accept''
      ];
      # extraNatPreroutingRules = [''udp dport 51820 dnat to 10.57.1.20''];
      extraNatPreroutingRules = ["ip daddr 95.165.105.90 tcp dport 25000-25010 dnat to 192.168.12.50" "ip daddr 95.165.105.90 udp dport 25000-25010 dnat to 192.168.12.50"];
      extraNatPostroutingRules = [''oifname "${wan}" masquerade'']; # ''ip daddr 10.57.1.20 masquerade''
      # extraMangleOutputRules = [''skuid 1000 counter mark set 701''];
    };

    bridges = {
      ${lan}.interfaces = ["${physLan}"];
      vms.interfaces = [];
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
      vms = {
        ipv4 = {
          addresses = [
            {
              address = "192.168.12.1";
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
