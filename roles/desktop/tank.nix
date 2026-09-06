{ config, lib, ... }:
let
  cfg = config.services.tankMount;
in
{
  options.services.tankMount.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to automount whale:/home/alex/tank over NFS";
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "nfs" ];

    systemd.mounts = [
      {
        type = "nfs";
        mountConfig = {
          Options = "rw,noatime,soft,timeo=30,retrans=3";
          TimeoutSec = 15;
        };
        what = "whale:/home/alex/tank";
        where = "/tank";
        after = [ "nebula@averyan.service" ];
        bindsTo = [ "nebula@averyan.service" ];
      }
    ];

    systemd.automounts = [
      {
        wantedBy = [ "multi-user.target" ];
        automountConfig = {
          TimeoutIdleSec = "300";
        };
        where = "/tank";
      }
    ];
  };

  # age.secrets.smb-tank.file = ../secrets/intpass/smb-tank.age;
  # boot.supportedFilesystems = ["cifs"];
  # # systemd.services.rpcbind.wants = ["systemd-tmpfiles-setup.service"];
  # # systemd.services.rpcbind.after = ["systemd-tmpfiles-setup.service"];

  # systemd.mounts = [
  #   {
  #     type = "smb3";
  #     mountConfig = {
  #       Options = "rw,credentials=${config.age.secrets.smb-tank.path},seal,resilienthandles,unix,uid=alex,gid=users";
  #     };
  #     what = "//10.57.1.10/tank";
  #     where = "/tank";
  #     after = ["nebula@averyan.service"];
  #     wants = ["nebula@averyan.service"];
  #   }
  # ];

  # systemd.automounts = [
  #   {
  #     wantedBy = ["multi-user.target"];
  #     automountConfig = {
  #       TimeoutIdleSec = "300";
  #     };
  #     where = "/tank";
  #   }
  # ];
}
