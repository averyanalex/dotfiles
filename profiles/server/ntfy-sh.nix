{
  services.ntfy-sh = {
    enable = true;
    settings = {
      listen-http = "127.0.0.1:8163";
    };
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/ntfy-sh";
      user = "ntfy-sh";
      group = "ntfy-sh";
      mode = "u=rwx,g=rx,o=rx";
    }
  ];
}
