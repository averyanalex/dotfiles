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

  # services.beesd.filesystems = {
  #   tank = {
  #     spec = "UUID=1934a7e9-adac-41ec-bbbc-a9fa45fd6f8c";
  #     hashTableSizeMB = 4096;
  #     verbosity = "crit";
  #     # extraOptions = ["--loadavg-target" "5.0"];
  #   };
  # };

  fileSystems."/tank" = {
    device = "/dev/whale/tank";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd:7" "subvol=@storage"];
  };

  fileSystems."/home/alex/tank" = {
    device = "UUID=7c1300ed-0fb0-419b-b98d-50de4c1a3d5a";
    fsType = "btrfs";
    options = ["compress=zstd:7" "subvol=@home"];
  };
  fileSystems."/home/alex/tank/hot" = {
    device = "UUID=bcfa404a-68de-4a25-9fb0-4e972c8f9423";
    fsType = "btrfs";
    options = ["compress=zstd:7" "subvol=@home"];
  };
}
