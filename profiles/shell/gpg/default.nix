{
  home-manager.users.alex = {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    programs.gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;
      publicKeys = [
        {
          source = ./averyanalex.asc;
          trust = 5;
        }
        {
          source = ./cofob.asc;
          trust = 4;
        }
      ];
    };
  };
}
