{
  lib,
  pkgs,
  config,
  ...
}: let
  nbminer = pkgs.buildFHSEnv {
    name = "nbminer";
    targetPkgs = pkgs: (with pkgs; [udev ocl-icd rocm-opencl-icd rocm-opencl-runtime]);
    runScript = "${pkgs.fetchzip {
      url = "https://dl.nbminer.com/NBMiner_42.3_Linux.tgz";
      sha256 = "2VGWWIKQbD1qkrat063fgo6ZiuRwTi8LU4YzyBWh1CA=";
    }}/nbminer";
  };
in {
  environment.systemPackages = [nbminer pkgs.xmrig];

  systemd.services.nbminer = {
    script = "${nbminer}/bin/nbminer -a kawpow -o stratum+tcp://neox.2miners.com:4040 -u GNsVwaW9mrbcHebmcRFVwHB1UwtV4dAu65.${config.networking.hostName}";
    after = ["network.target"];
    serviceConfig = {
      DynamicUser = true;
      User = "nbminer";
    };
  };

  systemd.services.gpu-mining-mode = {
    requiredBy = ["nbminer.service"];
    partOf = ["nbminer.service"];
    script = ''
      echo 185000000 > /sys/class/drm/card0/device/hwmon/hwmon4/power1_cap
    '';
    postStop = ''
      echo 255000000 > /sys/class/drm/card0/device/hwmon/hwmon4/power1_cap
    '';
    serviceConfig = {
      RemainAfterExit = true;
    };
  };

  services.xmrig = {
    enable = true;
    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = false;
      pools = [
        {
          algo = "rx/0";
          url = "zephyr.miningocean.org:5342";
          user = "ZEPHs8xb43NhoGw5RhCWKPQGfFyDyYpfLLozidcmBZyAZEGWZyYUepK4R6a1af2RhmiM7fczjtVwiMFLR5ZQQZUsBKZ2Tp7jyE2";
          pass = config.networking.hostName;
          keepalive = true;
        }
      ];
    };
  };

  systemd.services.xmrig.wantedBy = lib.mkForce [];
}
