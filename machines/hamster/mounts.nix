{
  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/a888e931-1a7b-4d04-bf86-340da74473eb";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9C88-9063";
    fsType = "vfat";
  };
}
