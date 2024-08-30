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
    nat.internalInterfaces = ["virbr0"];
  };
  systemd.network.networks."40-virbr0" = {
    networkConfig = {
      IPv6AcceptRA = false;
      ConfigureWithoutCarrier = true;
    };
    linkConfig.RequiredForOnline = false;
  };

  persist.state.dirs = ["/var/lib/libvirt"];
}
