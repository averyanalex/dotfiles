{
  pkgs,
  lib,
  ...
}: {
  boot.binfmt.emulatedSystems = lib.mkIf (pkgs.hostPlatform.system
    != "aarch64-linux") [
    "aarch64-linux"
  ];
}
