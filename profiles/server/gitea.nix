{
  services.gitea = {
    enable = true;
    rootUrl = "https://git.averyan.ru/";
    settings = {
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
      server.SSH_PORT = 7322;
    };
    lfs.enable = true;
    httpPort = 3816;
    domain = "git.averyan.ru";
    database = {
      type = "postgres";
      createDatabase = true;
    };
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/gitea";
      user = "gitea";
      group = "gitea";
      mode = "u=rwx,g=rx,o=";
    }
  ];
  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [3816];

  systemd.services.gitea = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };
}
