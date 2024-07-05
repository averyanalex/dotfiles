{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.self.nixosModules.roles.minimal
    inputs.self.nixosModules.hardware.aeza

    inputs.self.nixosModules.profiles.remote-builder-client
    inputs.self.nixosModules.profiles.server.aplusmuz

    ./mounts.nix
    ./tor.nix
    ./proxy.nix
  ];

  system.stateVersion = "23.05";

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

    nft-firewall = {
      extraFilterForwardRules = [
        "iifname wg0 oifname ens3 counter accept"
        "iifname ens3 oifname wg0 ct state { established, related } counter accept"
      ];
      extraNatPostroutingRules = ["oifname ens3 masquerade"];
    };

    firewall = {
      allowedUDPPorts = [51820];
    };

    wireguard.interfaces = {
      wg0 = {
        ips = ["10.8.7.1/24"];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wg-key.path;
        peers = [
          {
            # Whale
            publicKey = "nt2xC/cl5opg4g5fUkvqKuUKORXLS/qGCikx7F0FBRQ=";
            allowedIPs = ["10.8.8.0/24"];
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
          {
            # Swan
            publicKey = "nQ5xDVQnHI9nPDXW79z7Ks5FHE0o0bqxA5ZKzh9dgEU=";
            allowedIPs = ["10.8.7.248/32"];
          }
          {
            # Poplik
            publicKey = "s4xNXZAq83WzDbIA9w4Ori9MrPuA8lsYKYRldfcrrHc=";
            allowedIPs = ["10.8.7.249/32"];
          }
          {
            # Alligator
            publicKey = "FtRuoT3cvVFGq4DGbBNMSEYDvhygFvMDAHWEnSUgfjo=";
            allowedIPs = ["10.8.7.250/32"];
          }
          {
            # Semenkova
            publicKey = "BFtu1jwSTG81fmVOfO8r46430bBfabPQfW30uovp0lw=";
            allowedIPs = ["10.8.7.251/32"];
          }
          {
            # Buzurtanova
            publicKey = "F9IpR8uhuhvG798d6MeFgys7Ovjkr2EblitLUjrjS1I=";
            allowedIPs = ["10.8.7.252/32"];
          }
        ];
      };
    };
  };
}
