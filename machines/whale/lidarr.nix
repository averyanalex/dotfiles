{
  services.lidarr = {
    enable = true;
    group = "users";
    user = "alex";
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/lidarr";
      user = "alex";
      group = "users";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
