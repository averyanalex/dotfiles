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

  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home/alex/tank";
      ALLOW_USERS = ["alex"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
    home-hot = {
      SUBVOLUME = "/home/alex/tank/hot";
      ALLOW_USERS = ["alex"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
  };

  fileSystems."/home/alex/tank" = {
    device = "UUID=7c1300ed-0fb0-419b-b98d-50de4c1a3d5a";
    fsType = "btrfs";
    options = ["compress=zstd:7" "subvol=@home"];
  };

  services.beesd.filesystems = {
    tank = {
      spec = "UUID=7c1300ed-0fb0-419b-b98d-50de4c1a3d5a";
      hashTableSizeMB = 2048;
      # verbosity = "crit";
      extraOptions = ["--loadavg-target" "5.0"];
    };
  };

  fileSystems."/home/alex/tank/hot" = {
    device = "UUID=bcfa404a-68de-4a25-9fb0-4e972c8f9423";
    fsType = "btrfs";
    options = ["compress=zstd:7" "subvol=@home"];
  };
}
