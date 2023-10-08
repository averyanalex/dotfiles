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
          id = "CWES2IK-GJ5F2CI-4SXANKJ-5WOZKF7-5LBDF4U-2J7JSAJ-S3SSVN7-K5E3DAY";
        };
        hamster = {
          addresses = [
            "tcp://10.57.1.41:22000"
          ];
          id = "KF5NLPI-Z57MSPV-XZZXORA-QYVY5VR-GF2FHPW-EX3IUYS-MD5Z2S4-BMC6PAV";
        };
        grizzly = {
          addresses = [
            "tcp://10.57.1.60:22000"
          ];
          id = "INKDQLJ-APRGBRU-GB7FE4Z-3STOM5G-GHKK3UH-UKX2ZBT-4I7PWJB-BTYVAQD";
        };
        swan.id = "J52C7WU-R6UNI52-HIB2HON-2J3PUKM-6H74ROT-PY5V6YB-WATVFQC-KC6NGAY";
      };
      folders = {
        "Documents" = commonFolder "Documents";
        "projects" = commonFolder "projects" // {devices = allDevices ++ ["grizzly"];};
        "Music" = commonFolder "Music" // {devices = allDevices ++ ["swan"];};
        "Notes" = commonFolder "Notes" // {devices = allDevices ++ ["swan"];};
        "Pictures" = commonFolder "Pictures" // {devices = allDevices ++ ["swan"];};
      };
    };
  };

  # systemd.services.syncthing.after = ["multi-user.target"];

  persist.state.homeDirs = [".config/syncthing"];
}
