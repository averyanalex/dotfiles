{pkgs, ...}: {
  imports = [
    ./full.nix
  ];

  systemd = {
    enableEmergencyMode = false;

    watchdog = {
      runtimeTime = "30s";
      rebootTime = "10m";
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  hm.services.gpg-agent.pinentryPackage = pkgs.pinentry-curses;
}
