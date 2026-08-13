{ lib, ... }:
{
  boot.supportedFilesystems = [
    "ntfs"
    "btrfs"
    "exfat"
  ];

  services.fstrim.enable = lib.mkForce false;
}
