{ lib, ... }:
{
  imports = [
    ../../roles/desktop

    ../../profiles/netman.nix

    ./hardware.nix
    ./mounts.nix
    ./ssh-proxies.nix
  ];

  persist.enable = lib.mkForce false;
  services.syncthing.enable = lib.mkForce false;
  services.displayManager.autoLogin.enable = false;
  services.tankMount.enable = false;

  system.stateVersion = "26.05";
}
