{
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  persist.state.dirs = [
    "/etc/NetworkManager"
    "/var/lib/NetworkManager"
  ];
}
