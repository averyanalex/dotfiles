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
  teamredminer = pkgs.buildFHSEnv {
    name = "teamredminer";
    targetPkgs = pkgs: (with pkgs; [udev ocl-icd rocm-opencl-icd rocm-opencl-runtime]);
    runScript = "${pkgs.fetchzip {
      url = "https://github.com/todxx/teamredminer/releases/download/v0.10.14/teamredminer-v0.10.14-linux.tgz";
      sha256 = "AVRhJ9H6GtIsrqln/9qJOPWjQjBBBCwe7r+aYfbQwOc=";
    }}/teamredminer";
  };
  srbminer = pkgs.buildFHSEnv {
    name = "srbminer";
    targetPkgs = pkgs: (with pkgs; [udev ocl-icd rocm-opencl-icd rocm-opencl-runtime wget]);
    runScript = "${pkgs.fetchzip {
      url = "https://github.com/doktor83/SRBMiner-Multi/releases/download/2.3.2/SRBMiner-Multi-2-3-2-Linux.tar.xz";
      sha256 = "USYOskiwzLhOxQV4UAy5sseL0KOzZmpFCGL1vaTe1/M=";
    }}/SRBMiner-MULTI";
  };
  xmrig = pkgs.stable.xmrig;

  srbArgs = "--algorithm dynex --disable-cpu --pool stratum+tcp://dnx.mineradnow.space:18000 --mallob-endpoint https://gomallob.mineradnow.space/ml --wallet Xwn38pD2orDM7e1YSvwtyx6Jm7cebb9nKhnaneoist2QYyLqmUUTQJcTDgnM4X3qjsZrgfgojbnGEZRVepMAQYce28bdcprRp --password ${config.networking.hostName}";
  # srbArgs = ''--algorithm dynex\;sha256dt --pool stratum+tcp://dnx.mineradnow.space:18000\;stratum+tcp://sha256dt.mine.zergpool.com:3341 --wallet Xwn38pD2orDM7e1YSvwtyx6Jm7cebb9nKhnaneoist2QYyLqmUUTQJcTDgnM4X3qjsZrgfgojbnGEZRVepMAQYce28bdcprRp\;bitcoincash:qq6qj3tg52w50meq8syp33yaqdqqlv5cvqptjlej74 --password x\;c=BCH,ID=${config.networking.hostName} --cpu-threads -1\;-1'';

  # gpuArgs = "-a firopow -o stratum+tcp://firopow.mine.zergpool.com:3001 -u \"bitcoincash:qq6qj3tg52w50meq8syp33yaqdqqlv5cvqptjlej74\" -p \"c=BCH,ID=${config.networking.hostName}\"";
  gpuArgs = "-a kawpow -o stratum+tcp://kawpow.mine.zergpool.com:3638 -u \"bitcoincash:qq6qj3tg52w50meq8syp33yaqdqqlv5cvqptjlej74\" -p \"c=BCH,ID=${config.networking.hostName}\"";
in {
  environment.systemPackages = [nbminer teamredminer xmrig srbminer];

  systemd.services.nbminer = {
    script = "${nbminer}/bin/nbminer ${gpuArgs}";
    after = ["network.target"];
    serviceConfig = {
      DynamicUser = true;
      SupplementaryGroups = ["video"];
      User = "nbminer";
    };
  };

  systemd.services.teamredminer = {
    script = "${teamredminer}/bin/teamredminer ${gpuArgs}";
    after = ["network.target"];
    serviceConfig = {
      DynamicUser = true;
      SupplementaryGroups = ["video"];
      User = "teamredminer";
    };
  };

  systemd.services.srbminer = {
    script = "${srbminer}/bin/srbminer ${srbArgs}";
    after = ["network.target"];
    serviceConfig = {
      DynamicUser = true;
      SupplementaryGroups = ["video"];
      User = "srbminer";
    };
  };

  security.audit.enable = true;
  security.auditd.enable = true;

  systemd.services.gpu-mining-mode = {
    requiredBy = ["nbminer.service" "teamredminer.service" "srbminer.service"];
    partOf = ["nbminer.service" "teamredminer.service" "srbminer.service"];
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
    package = xmrig;
    settings = {
      autosave = true;
      cpu = true;
      opencl = false;
      cuda = false;
      pools = [
        {
          algo = "yescrypt"; # "rx/0";
          url = "yescrypt.mine.zergpool.com:6233"; # "randomx.eu.mine.zergpool.com:4453";
          user = "bitcoincash:qq6qj3tg52w50meq8syp33yaqdqqlv5cvqptjlej74";
          pass = "c=BCH,ID=${config.networking.hostName}";
          keepalive = true;
        }
      ];
    };
  };

  systemd.services.xmrig.wantedBy = lib.mkForce [];
}
