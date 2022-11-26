{
  networking.networkmanager.enable = true;
  persist.state.dirs = [
    "/etc/NetworkManager"
    "/var/lib/NetworkManager"
  ];
}
