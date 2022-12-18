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

      mkdir -p /persist/ptero/panel
    '';
  };

  age.secrets.pterodactyl-panel-passwords.file = ../../secrets/intpass/pterodactyl-panel.age;
  age.secrets.pterodactyl-redis-password.file = ../../secrets/intpass/pterodactyl-redis.age;

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
      "/srv/pterodactyl/" = {
        hostPath = "/persist/ptero/panel";
        isReadOnly = false;
      };
      "/run/panel.env".hostPath = config.age.secrets.pterodactyl-panel-passwords.path;
      "/run/redis-pass".hostPath = config.age.secrets.pterodactyl-redis-password.path;
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

      virtualisation.oci-containers = {
        backend = "docker";
        containers = {
          panel = {
            image = "ghcr.io/pterodactyl/panel:v1.11.2";
            volumes = [
              "/srv/pterodactyl/var/:/app/var/"
              "/srv/pterodactyl/logs/:/app/storage/logs"
            ];
            extraOptions = [ "--network=host" ];
            environment = {
              APP_URL = "https://ptero.averyan.ru";
              APP_TIMEZONE = "Europe/Moscow";
              APP_SERVICE_AUTHOR = "alex@averyan.ru";
              APP_ENV = "production";
              APP_ENVIRONMENT_ONLY = "false";

              CACHE_DRIVER = "redis";
              SESSION_DRIVER = "redis";
              QUEUE_DRIVER = "redis";
              REDIS_HOST = "127.0.0.1";
              REDIS_PORT = "6379";

              DB_HOST = "127.0.0.1";
              DB_PORT = "3306";
              DB_DATABASE = "panel";
              DB_USERNAME = "panel";
            };
            environmentFiles = [ "/run/panel.env" ];
          };
        };
      };

      virtualisation.docker = {
        enable = true;
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
        };
      };

      services.redis.servers.panel = {
        enable = true;
        port = 6379;
        requirePassFile = "/run/redis-pass";
      };

      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = [ "panel" ];
        ensureUsers = [{
          name = "panel";
          ensurePermissions = {
            "panel.*" = "ALL PRIVILEGES";
          };
        }];
      };
    };
  };
}
