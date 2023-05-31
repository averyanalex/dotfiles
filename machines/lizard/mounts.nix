{
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/b3ed9a9f-ec2e-4fcd-a46f-93d735af4125";
    fsType = "ext4";
    # options = ["discard"];
  };

  # fileSystems."/boot/firmware" = {
  #   device = "/dev/disk/by-label/FIRMWARE";
  #   fsType = "vfat";
  # };

  persist.state.dirs = ["/boot"];
}
