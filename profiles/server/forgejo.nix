{
  services.forgejo = {
    enable = true;
    settings = {
      server = {
        ROOT_URL = "https://git.neutrino.su/";
        HTTP_PORT = 3826;
        DOMAIN = "git.neutrino.su";
        # SSH_PORT = 7422;
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
    };
    lfs.enable = true;
    database = {
      type = "postgres";
      createDatabase = true;
    };
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/forgejo";
      user = "forgejo";
      group = "forgejo";
      mode = "u=rwx,g=rx,o=";
    }
  ];
  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [3826 7422];

  systemd.services.forgejo = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };
}
