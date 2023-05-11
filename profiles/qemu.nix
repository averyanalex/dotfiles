{pkgs, ...}: {
  boot.binfmt.emulatedSystems = [
    # "x86_64-linux"
    "aarch64-linux"
  ];
}
