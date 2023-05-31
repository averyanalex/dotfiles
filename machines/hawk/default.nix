{
  inputs,
  config,
  ...
}: let
  makeAveryanHost = proxyPass: {
    locations."/".proxyPass = proxyPass;
    locations."/".proxyWebsockets = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    useACMEHost = "averyan.ru";
    forceSSL = true;
    kTLS = true;
  };
in {
  imports = [
    inputs.self.nixosModules.profiles.remote-builder-client
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

  # TODO: refactor nginx

  services.nginx.virtualHosts = {
    "bw.averyan.ru" = makeAveryanHost "http://whale:8222";
    "dav.averyan.ru" = makeAveryanHost "http://whale:5232";
    "git.averyan.ru" = makeAveryanHost "http://whale:3816";
    "grafana.averyan.ru" = makeAveryanHost "http://whale:3729";
    "home.averyan.ru" = makeAveryanHost "http://whale:8123";
    "dacha.averyan.ru" = makeAveryanHost "http://lizard:8123";
    "hydra.averyan.ru" = makeAveryanHost "http://whale:2875";
    "olsearch.averyan.ru" = makeAveryanHost "http://whale:8739";
    "prism.averyan.ru" = makeAveryanHost "http://whale:2342";
    "yacy.averyan.ru" = makeAveryanHost "http://whale:8627";

    "ptero.averyan.ru" = makeAveryanHost "http://10.8.7.80:80";
    "whale-ptero.averyan.ru" = makeAveryanHost "http://10.8.7.80:443";
  };

  services.prometheus.exporters.wireguard.enable = true;

  services.yggdrasil.settings.Peers = [
    "tcp://45.95.202.21:12403"
    "tcp://77.37.218.131:12402"
    "tcp://gutsche.tech:8888"
    "tls://178.20.45.32:65535"
    "tls://45.147.198.155:6010"
    "tls://45.147.200.202:443"
    "tls://94.103.82.150:8080"
    "tls://box.paulll.cc:13338"
  ];

  networking = {
    defaultGateway = {
      address = "10.0.0.1";
      interface = "ens3";
    };
    # defaultGateway6 = {
    #   address = "2a0e:d606:0:1af::1";
    #   interface = "ens3";
    # };

    nft-firewall = {
      extraFilterForwardRules = [
        "iifname wg0 oifname ens3 counter accept"
        "iifname ens3 oifname wg0 ct state { established, related } counter accept"
      ];
      extraNatPreroutingRules = [
        "ip daddr 185.112.83.99 tcp dport 25000-25100 dnat to 10.8.7.80"
        "ip daddr 185.112.83.99 tcp dport 25565 dnat to 10.8.7.81"
        "ip daddr 185.112.83.99 tcp dport 2022 dnat to 10.8.7.80"
        "ip daddr 185.112.83.99 udp dport 25000-25100 dnat to 10.8.7.80"
      ];
      extraNatPostroutingRules = ["oifname ens3 masquerade"];
    };

    firewall = {
      allowedUDPPorts = [51820];
      interfaces."nebula.averyan".allowedTCPPorts = [9586]; # wg exporter
    };

    wireguard.interfaces = {
      wg0 = {
        ips = ["10.8.7.1/24"];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wg-key.path;
        peers = [
          {
            # Pocoft
            publicKey = "9vFNcLY6iWyHToTduhYD5m5Kj7v4RfERqC0pIWphsgU=";
            allowedIPs = ["10.8.7.2/32"];
          }
          {
            # Pterodactyl (Whale)
            publicKey = "yZxLSiGRW5kqk3qT4Yvei732+i2UWLA4fS/H6AJbPVY=";
            allowedIPs = ["10.8.7.80/32"];
          }
          {
            # Firesquare (Whale)
            publicKey = "fwxaU8/D7awGaEcDuDVqssk7lkUoNuAsv3vR132XRlQ=";
            allowedIPs = ["10.8.7.81/32"];
          }
          {
            # Vsevolod
            publicKey = "oKrAQE4sX4YjNf13qJz9IjprAH6YFhmt7CDUzXJVXl8=";
            allowedIPs = ["10.8.7.240/32"];
          }
          {
            # Kriger
            publicKey = "qxkQlt1Q9lHq+d48J9nkqTTC+Dzs2LHD+GycsSKDyyE=";
            allowedIPs = ["10.8.7.241/32"];
          }
          {
            # Ivanov
            publicKey = "bqkblOYoMi69RAIvJTy/zhovdUR+2O7JVaXoUqBXM2I=";
            allowedIPs = ["10.8.7.242/32"];
          }
          {
            # Tihonov
            publicKey = "mi4FUaRyD2yIbVtX1jC7cY7XXg6rUELcpAUyN+N7lU0=";
            allowedIPs = ["10.8.7.243/32"];
          }
          {
            # Despectdr
            publicKey = "/BRUH/MivTgVsGeTINUQ5pZDtX8nzrEv1vy+wNJE0Ws=";
            allowedIPs = ["10.8.7.244/32"];
          }
          {
            # Khrustaleva
            publicKey = "fZS0Loc8VTcARnokFwR4pgTiP+warZLa2IYHefiD8ho=";
            allowedIPs = ["10.8.7.245/32"];
          }
          {
            # Kazakova
            publicKey = "eoofp8UhHTo9SAgSDQmBKrqeF2me1goHIunWWE4Og1c=";
            allowedIPs = ["10.8.7.246/32"];
          }
          {
            # Karaseva
            publicKey = "dBmTwssDWdv+kQfnDl1sMdF7P6+E3szdJPud34tWq1k=";
            allowedIPs = ["10.8.7.247/32"];
          }
        ];
      };
    };

    nebula-averyan.isLighthouse = true;

    interfaces = {
      ens3 = {
        ipv4 = {
          addresses = [
            {
              address = "185.112.83.99";
              prefixLength = 32;
            }
          ];
        };
        # ipv6 = {
        #   addresses = [
        #     {
        #       address = "2a0e:d606:0:1af::a";
        #       prefixLength = 64;
        #     }
        #   ];
        # };
      };
    };
  };
}
