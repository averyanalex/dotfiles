{ pkgs, ... }:
{
  services.borgbackup.repos.qfzwufeu = {
    quota = "150G";
    path = "/var/lib/borgbackup/qfzwufeu";
    authorizedKeysAppendOnly = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAm0keIU4qYLB0yb1sRv068glIUZqBVmbGpZPc1MDBFo"
    ];
  };

  services.borgbackup.repos.emerald = {
    quota = "200G";
    path = "/var/lib/borgbackup/emerald";
    authorizedKeysAppendOnly = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINN/1XPmuJAEJC5F2KWm/XosIF1z6zWNOE2LYpEtn/N+ emerald-backup"
    ];
  };

  fileSystems."/var/lib/borgbackup" = {
    device = "UUID=bcfa404a-68de-4a25-9fb0-4e972c8f9423";
    fsType = "btrfs";
    options = [
      "compress=zstd:7"
      "noatime"
      "subvol=@borgbackup"
    ];
  };

  systemd.services = {
    borgbackup-no-compression = {
      description = "Disable CoW and compression for the BorgBackup subvolume";
      requires = [ "var-lib-borgbackup.mount" ];
      after = [ "var-lib-borgbackup.mount" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.e2fsprogs}/bin/chattr +C /var/lib/borgbackup";
      };
    };

    borgbackup-repo-qfzwufeu = {
      requires = [ "borgbackup-no-compression.service" ];
      after = [ "borgbackup-no-compression.service" ];
    };

    borgbackup-repo-emerald = {
      requires = [ "borgbackup-no-compression.service" ];
      after = [ "borgbackup-no-compression.service" ];
    };
  };
}
