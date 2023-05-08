{
  persist.state.dirs = [
    {
      directory = "/var/log/journal";
      user = "root";
      group = "systemd-journal";
      mode = "u=rwx,g=rs,o=rx";
    }
  ];
}
