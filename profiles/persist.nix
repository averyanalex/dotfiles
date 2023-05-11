{
  persist = {
    enable = true;
    hideMounts = true;
    username = "alex";
  };

  persist.state.dirs = [
    {
      directory = "/var/tmp";
      mode = "1777";
    }
  ];

  services.openssh.hostKeys = [
    {
      bits = 4096;
      path = "/persist/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      path = "/persist/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
}
