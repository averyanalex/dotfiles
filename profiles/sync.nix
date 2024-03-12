{
  lib,
  config,
  ...
}: let
  allDevices = ["hamster" "alligator" "whale"];
  commonFolder = name: {
    label = name;
    id = lib.strings.toLower name;
    path = "${config.services.syncthing.dataDir}/${name}";
    ignorePerms = false;
    devices = allDevices;
  };
in {
  services.syncthing = {
    enable = true;

    user = "alex";
    group = "users";

    dataDir = lib.mkDefault "/home/alex";
    configDir = "/home/alex/.config/syncthing";

    openDefaultPorts = true;

    settings = {
      devices = {
        alligator = {
          addresses = [
            "tcp://192.168.3.60:22000"
            "tcp://10.57.1.40:22000"
          ];
          id = "XYYXB6U-Y24PGXJ-UEDYSHQ-HKYELXG-UF6I4S4-EKB3GB3-KU6DEUH-5JDCOAN";
        };
        whale = {
          addresses = [
            "tcp://whale.averyan.ru:22000"
          ];
          id = "Q3SH2WU-IZ2DW2W-PGYCBXF-TR4LOSK-Z4C3TBU-PDMVA77-AJ3K55U-OODJKAG";
        };
        hamster = {
          addresses = [
            "tcp://10.57.1.41:22000"
          ];
          id = "5RVWUHC-DYOYNZV-P4AYHJ5-ZNRLCKV-UWS2B7C-BUYENMF-GXNXYSX-NIKAMAN";
        };
        swan.id = "J52C7WU-R6UNI52-HIB2HON-2J3PUKM-6H74ROT-PY5V6YB-WATVFQC-KC6NGAY";
      };
      folders = {
        "Documents" = commonFolder "Documents";
        "projects" = commonFolder "projects";
        "Music" = commonFolder "Music" // {devices = allDevices ++ ["swan"];};
        "Notes" = commonFolder "Notes" // {devices = allDevices ++ ["swan"];};
        "Pictures" = commonFolder "Pictures" // {devices = allDevices ++ ["swan"];};
      };
    };
  };

  # systemd.services.syncthing.after = ["multi-user.target"];

  persist.state.homeDirs = [".config/syncthing"];
}
