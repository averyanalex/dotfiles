{
  fileSystems."/persist" = {
    device = "/dev/hamster/data";
    fsType = "ext4";
    options = ["discard"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9C88-9063";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/hamster/swap";
      discardPolicy = "both";
    }
  ];
}
