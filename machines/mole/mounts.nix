{
  fileSystems."/" = {
    device = "/dev/disk/by-label/mole-system";
    fsType = "btrfs";
    options = [
      "discard=async"
      "compress=zstd"
      "subvol=@"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/mole-system";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "discard=async"
      "compress=zstd"
      "subvol=@home"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/mole-system";
    fsType = "btrfs";
    neededForBoot = true;
    options = [
      "discard=async"
      "compress=zstd"
      "subvol=@nix"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-label/mole-system";
    fsType = "btrfs";
    options = [
      "discard=async"
      "compress=zstd"
      "subvol=@logs"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/MOLEBOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/mole-swap";
      discardPolicy = "both";
    }
  ];
}
