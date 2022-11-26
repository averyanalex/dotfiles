{
  fileSystems."/persist" = {
    device = "/dev/whale/data";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p2";
    fsType = "vfat";
  };
}
