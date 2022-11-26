{
  fileSystems."/persist" = {
    device = "/dev/vda2";
    fsType = "ext4";
    options = [ "discard" ];
  };
}
