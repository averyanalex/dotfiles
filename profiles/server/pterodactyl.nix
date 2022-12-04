{ config, pkgs, ... }:
{
  containers.pterodactyl = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    localAddress = "192.168.12.20/24";
    hostBridge = "vm0";

    extraFlags = [ "--system-call-filter=@keyring" "--system-call-filter=bpf" ];

    config = { config, pkgs, ... }: {
      system.stateVersion = "22.11";
      networking.defaultGateway = {
        address = "192.168.12.1";
        interface = "eth0";
      };

      virtualisation.docker = {
        enable = true;
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
        };
      };

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };
    };
  };
}
