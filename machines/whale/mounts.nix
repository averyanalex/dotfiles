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

  fileSystems."/tank" = {
    device = "/dev/whale/tank";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/tank/dwnl" = {
    device = "/dev/whale/dwnl";
    fsType = "ext4";
    options = [ "discard" ];
  };
}
