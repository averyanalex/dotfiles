{pkgs, ...}: {
  home-manager.users.alex = {
    dconf.settings = {
      "org/virt-manager/virt-manager".xmleditor-enabled = true;
      "org/virt-manager/virt-manager/connections".uris = ["qemu+ssh://alex@hamster/system" "qemu:///system"];
      "org/virt-manager/virt-manager/connections".autoconnect = ["qemu:///system"];
    };
    home.packages = [pkgs.virt-manager];
  };

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  virtualisation.libvirtd.enable = true;
  users.users.alex.extraGroups = ["libvirtd"];

  networking = {
    bridges.virbr0.interfaces = [];
    interfaces.virbr0 = {
      ipv4 = {
        addresses = [
          {
            address = "10.34.82.1";
            prefixLength = 24;
          }
        ];
      };
    };
    nft-firewall = {
      extraFilterForwardRules = [
        ''iifname "virbr0" counter accept''
        ''oifname "virbr0" ct state { established, related } counter accept''
      ];
      extraNatPostroutingRules = [
        ''iifname "virbr0" masquerade''
      ];
    };
  };
  systemd.network.networks."40-virbr0" = {
    networkConfig = {
      IPv6AcceptRA = false;
      ConfigureWithoutCarrier = true;
    };
    linkConfig.RequiredForOnline = false;
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.conf.default.forwarding" = true;
  };

  persist.state.dirs = ["/var/lib/libvirt"];
}
