{
  power.ups = {
    enable = true;
    ups.exegate = {
      description = "ExeGate SpecialPro Smart LLB-2000";
      driver = "nutdrv_qx"; # "richcomm_usb";
      port = "auto";
      directives = ["vendorid = 0925" "productid = 1234" "pollinterval = 1" "pollfreq = 5"];
    };
  };
  # users = {
  #   users.nut = {
  #     isSystemUser = true;
  #     group = "nut";
  #     home = "/var/lib/nut";
  #     createHome = true;
  #   };
  #   groups.nut = { };
  # };
  # services.udev.extraRules = ''
  #   SUBSYSTEM=="usb", ATTRS{idVendor}=="0925", ATTRS{idProduct}=="1234", MODE="664", GROUP="nut", OWNER="nut"
  # '';
  # systemd.services.upsd.serviceConfig = {
  #   User = "nut";
  #   Group = "nut";
  # };
  # systemd.services.upsdrv.serviceConfig = {
  #   User = "nut";
  #   Group = "nut";
  # };
  environment.etc = {
    upsdConf = {
      text = "";
      target = "nut/upsd.conf";
      mode = "0440";
      # group = "nut";
      # user = "nut";
    };
    upsdUsers = {
      text = ''
        [upsmon]
          password = ups
          upsmon master
      '';
      target = "nut/upsd.users";
      mode = "0440";
      # group = "nut";
      # user = "nut";
    };
    upsmonConf = {
      # RUN_AS_USER nut
      text = ''
        MINSUPPLIES 1
        SHUTDOWNCMD "shutdown -h 0"
        POLLFREQ 5
        POLLFREQALERT 5
        HOSTSYNC 15
        DEADTIME 15
        RBWARNTIME 43200
        NOCOMMWARNTIME 300
        FINALDELAY 5
        MONITOR exegate@localhost 1 upsmon ups master
      '';
      target = "nut/upsmon.conf";
      mode = "0444";
    };
  };
  systemd.tmpfiles.rules = [
    "d '/var/lib/nut/' 0700 root root - -"
  ];
  # services.apcupsd = {
  #   enable = true;
  #   configText = ''
  #     UPSCABLE usb
  #     UPSTYPE usb
  #     DEVICE
  #     NISIP 127.0.0.1
  #     BATTERYLEVEL 10
  #     MINUTES 5
  #   '';
  # };

  services.prometheus.exporters.nut = {
    enable = true;
  };
}
