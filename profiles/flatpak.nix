{pkgs, ...}: {
  services.flatpak.enable = true;
  services.dbus.enable = true;
  persist.state.dirs = ["/var/lib/flatpak"];
  persist.state.homeDirs = [".var/app"];
}
