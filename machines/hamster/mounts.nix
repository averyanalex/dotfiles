{
  services.lvm.boot.thin.enable = true;

  fileSystems."/persist" = {
    device = "/dev/hamster/data";
    fsType = "btrfs";
    options = ["discard=async" "compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0B94-3F5F";
    fsType = "vfat";
  };

  # swapDevices = [
  #   {
  #     device = "/dev/hamster/swap";
  #     discardPolicy = "both";
  #   }
  # ];
}
