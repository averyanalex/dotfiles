{
  pkgs,
  lib,
  ...
}: {
  services.matomo = {
    enable = true;
    package = pkgs.matomo_5;
    nginx = {
      enableACME = false;
      useACMEHost = "neutrino.su";
      quic = lib.mkForce true;
      kTLS = lib.mkForce true;
    };
    hostname = "matomo.neutrino.su";
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/matomo";
      user = "matomo";
      group = "matomo";
      mode = "u=rwx,g=,o=";
    }
  ];
}
