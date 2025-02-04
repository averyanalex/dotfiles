{
  services.lvm.boot.thin.enable = true;

  fileSystems."/persist" = {
    device = "/dev/hamster/data";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd" "subvol=@"];
  };

  fileSystems."/persist/home" = {
    device = "/dev/hamster/data";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd" "subvol=@home"];
  };

  fileSystems."/nix" = {
    device = "/dev/hamster/data";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd" "subvol=@nix"];
  };

  persist.linkNix = false;

  # services.beesd.filesystems = {
  #   tank = {
  #     spec = "UUID=1c6b1fc4-5a65-43e9-bef3-db168f6bbd0d";
  #     hashTableSizeMB = 128;
  #     verbosity = "crit";
  #     extraOptions = ["--loadavg-target" "5.0"];
  #   };
  # };

  # services.snapper.configs = {
  #   persist = {
  #     SUBVOLUME = "/persist";
  #     ALLOW_USERS = ["alex"];
  #     TIMELINE_CREATE = true;
  #     TIMELINE_CLEANUP = true;
  #   };
  # };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/hamster/swap";
      discardPolicy = "both";
    }
  ];
}
