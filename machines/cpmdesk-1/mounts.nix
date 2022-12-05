{
  fileSystems."/persist" = {
    device = "/dev/sda2";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };
}
