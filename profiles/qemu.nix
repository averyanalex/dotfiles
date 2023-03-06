{ pkgs, ... }:
{
  boot.binfmt.emulatedSystems = [
    "x86_64-windows"
    "aarch64-linux"
  ];
}
 