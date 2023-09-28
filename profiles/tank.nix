{
  boot.supportedFilesystems = ["nfs"];
  # systemd.services.rpcbind.wants = ["systemd-tmpfiles-setup.service"];
  # systemd.services.rpcbind.after = ["systemd-tmpfiles-setup.service"];

  systemd.mounts = [
    {
      type = "nfs";
      mountConfig = {
        Options = "noatime";
      };
      what = "10.57.1.10:/home/alex/tank";
      where = "/tank";
      after = ["nebula@averyan.service"];
      wants = ["nebula@averyan.service"];
    }
  ];

  systemd.automounts = [
    {
      wantedBy = ["multi-user.target"];
      automountConfig = {
        TimeoutIdleSec = "600";
      };
      where = "/tank";
    }
  ];
}
