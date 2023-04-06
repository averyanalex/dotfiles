{
  persist = {
    enable = true;
    hideMounts = true;
    username = "alex";
  };

  persist.state.dirs = [
    {
      directory = "/var/tmp";
      user = "hass";
      group = "hass";
      mode = "1777";
    }
  ];
}
