{ lib, ... }:
{
  virtualisation.libvirtd.enable = true;
  users.users.alex.extraGroups = [ "libvirtd" ];
  virtualisation.libvirtd.allowedBridges = lib.mkForce [ ];

  persist.state.dirs = [ "/var/lib/libvirt" ];
}
