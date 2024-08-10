{
  # services.borgbackup.repos.main = {};

  fileSystems."/var/lib/borgbackup" = {
    device = "UUID=bcfa404a-68de-4a25-9fb0-4e972c8f9423";
    fsType = "btrfs";
    options = ["compress=none" "noatime" "subvol=@borgbackup"];
  };
}
