{ lib, config, ... }:

let
  allDevices = [ "hamster" "alligator" "pocoft" ];
  commonFolder = name: {
    label = name;
    id = lib.strings.toLower name;
    path = "${config.services.syncthing.dataDir}/${name}";
    ignorePerms = false;
    devices = allDevices;
  };
in
{
  services.syncthing = {
    enable = true;

    user = "alex";
    group = "users";

    dataDir = "/home/alex";
    configDir = "/home/alex/.config/syncthing";

    openDefaultPorts = true;

    devices = {
      alligator = {
        addresses = [
          "tcp://192.168.3.60:22000"
          "tcp://10.5.3.101:22000"
        ];
        id = "XYYXB6U-Y24PGXJ-UEDYSHQ-HKYELXG-UF6I4S4-EKB3GB3-KU6DEUH-5JDCOAN";
      };
      hamster = {
        addresses = [
          "tcp://10.5.3.100:22000"
        ];
        id = "KF5NLPI-Z57MSPV-XZZXORA-QYVY5VR-GF2FHPW-EX3IUYS-MD5Z2S4-BMC6PAV";
      };
      pocoft.id = "T5HBUVC-EU6A5BT-W4VFH3R-YBIYBCF-DLLKHVU-QDZC7YS-XGBFNPP-SSZSBA2";
    };
    folders = {
      "Music" = commonFolder "Music";
      "Documents" = commonFolder "Documents";
      "Pictures" = commonFolder "Pictures";
    };
  };

  persist.state.homeDirs = [ ".config/syncthing" ];
}
