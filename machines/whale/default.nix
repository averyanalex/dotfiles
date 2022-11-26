{ inputs, config, ... }:
let
  wan = "enp6s0";
  physLan = "enp5s0";
  lan = "lan0";
in
{
  imports = [
    inputs.self.nixosModules.roles.server
    inputs.self.nixosModules.profiles.libvirt
    inputs.self.nixosModules.profiles.pgsql
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

  networking = {
    hostName = "whale";

    nebula-averyan.enable = true;
    nebula-frsqr.enable = true;

    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain output {
            type filter hook output priority 100;
            accept
          }

          chain input {
            type filter hook input priority 0;

            ct state invalid counter drop comment "drop invalid packets"
            ct state { established, related } counter accept comment "accept traffic originated from us"

            iifname lo counter accept comment "accept any localhost traffic"
            tcp dport 22 counter accept comment "ssh"
            iifname "nebula.frsqr" tcp dport 9100 counter accept comment "node exporter"
            udp dport 60000-61000 counter accept comment "mosh"

            ip6 nexthdr icmpv6 icmpv6 type {
              destination-unreachable,
              packet-too-big,
              time-exceeded,
              parameter-problem,
              nd-router-advert,
              nd-neighbor-solicit,
              nd-neighbor-advert
            } counter accept comment "icmpv6"
            ip protocol icmp icmp type {
              destination-unreachable,
              router-advertisement,
              time-exceeded,
              parameter-problem
            } counter accept comment "icmpv4"

            ip6 nexthdr icmpv6 icmpv6 type echo-request counter accept comment "pingv6"
            ip protocol icmp icmp type echo-request counter accept comment "pingv4"

            counter drop
          }

          chain forward {
            type filter hook forward priority 0;

            iifname { "${lan}", "vm0" } oifname "${wan}" counter accept comment "allow LAN to WAN"
            iifname "${wan}" oifname { "${lan}", "vm0" } ct state { established, related } counter accept comment "allow established back to LAN"

            # ct status dnat counter accept comment "allow dnat forwarding"
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
          }

          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            oifname "${wan}" masquerade
          }
        }
      '';
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
