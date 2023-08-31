{
  fileSystems."/persist" = {
    device = "/dev/whale/data";
    fsType = "ext4";
    options = ["discard"];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p2";
    fsType = "vfat";
  };

  fileSystems."/hdd" = {
    device = "/dev/whale/storage";
    fsType = "ext4";
    options = ["discard"];
  };

  services.beesd.filesystems = {
    tank = {
      spec = "UUID=1934a7e9-adac-41ec-bbbc-a9fa45fd6f8c";
      hashTableSizeMB = 4096;
      verbosity = "crit";
      # extraOptions = ["--loadavg-target" "5.0"];
    };
  };

  fileSystems."/tank" = {
    device = "/dev/whale/tank";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd:7" "subvol=@storage"];
  };

  fileSystems."/home/alex/tank" = {
    device = "/dev/whale/tank";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd:7" "subvol=@home"];
  };
}
