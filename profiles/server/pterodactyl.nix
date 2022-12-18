{ config, pkgs, ... }:
{
  age.secrets.wg-key-pterodactyl.file = ../../secrets/wireguard/pterodactyl.age;
  networking.wireguard.interfaces = {
    wg-pterodactyl = {
      allowedIPsAsRoutes = false;
      privateKeyFile = config.age.secrets.wg-key-pterodactyl.path;
      peers = [
        {
          publicKey = "h+76esMcmPLakUN/1vDlvGGf2Ovmw/IDKKxFtqXCdm8=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "hawk.averyan.ru:51820";
          persistentKeepalive = 15;
        }
      ];
    };
  };

  systemd.services."container@pterodactyl" = {
    wants = [ "wireguard-wg-pterodactyl.target" "setup-pterodactyl-dirs.service" ];
    after = [ "wireguard-wg-pterodactyl.target" "setup-pterodactyl-dirs.service" ];
  };

  systemd.services.setup-pterodactyl-dirs = {
    script = ''
      mkdir -p /persist/ptero/mysql
      chown 84:84 /persist/ptero/mysql
      chmod 700 /persist/ptero/mysql
    '';
  };

  containers.pterodactyl = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    interfaces = [ "wg-pterodactyl" ];

    extraFlags = [ "--system-call-filter=@keyring" "--system-call-filter=bpf" ];

    bindMounts = {
      "/var/lib/mysql/" = {
        hostPath = "/persist/ptero/mysql";
        isReadOnly = false;
      };
    };

    config = { config, pkgs, ... }: {
      system.stateVersion = "22.11";

      networking = {
        interfaces.wg-pterodactyl.ipv4.addresses = [{
          address = "10.8.7.80";
          prefixLength = 32;
        }];
        defaultGateway = {
          address = "10.8.7.1";
          interface = "wg-pterodactyl";
        };
        firewall.enable = false;
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
