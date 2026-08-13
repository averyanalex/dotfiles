let
  hostAddress = "95.165.105.90";
  machineAddress = "10.78.0.15";
  sshForwardPort = 17428;
  btrfsPoolPath = "/var/lib/incus-btrfs";
in
{
  fileSystems.${btrfsPoolPath} = {
    device = "UUID=2c7a9cef-7b9a-4cfb-b8e1-9e47ef89b628";
    fsType = "btrfs";
    options = [
      "compress=zstd:3"
      "discard=async"
      "noatime"
      "subvol=@incus"
    ];
  };

  # @incus must be empty before this generation is deployed. Keep the shared
  # dir-backed default pool until every instance has been migrated and verified.
  virtualisation.incus.preseed.storage_pools = [
    {
      name = "btrfs";
      driver = "btrfs";
      # Incus 7.0 does not accept volume.btrfs.compression as a pool default;
      # the declarative mount above applies zstd:3 to newly written data.
      config.source = btrfsPoolPath;
    }
  ];

  systemd.services = {
    incus.unitConfig.RequiresMountsFor = [ btrfsPoolPath ];
    incus-preseed.unitConfig.RequiresMountsFor = [ btrfsPoolPath ];
    incus-startup.unitConfig.RequiresMountsFor = [ btrfsPoolPath ];
  };

  systemd.network.networks."40-inoprbr0".dhcpServerStaticLeases = [
    {
      MACAddress = "10:66:6a:74:86:1d";
      Address = machineAddress;
    }
  ];

  systemd.network.networks."40-incusbr0".dhcpServerStaticLeases = [
    {
      MACAddress = "10:66:6a:0e:1d:78";
      Address = "10.77.0.45";
    }
  ];

  networking.nat.forwardPorts = [
    {
      sourcePort = sshForwardPort;
      proto = "tcp";
      destination = "${machineAddress}:22";
      loopbackIPs = [ hostAddress ];
    }
  ];

  networking.firewall.allowedTCPPorts = [ sshForwardPort ];
}
