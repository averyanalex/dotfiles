{config, ...}: {
  systemd.services."container@pterodactyl" = {
    requires = ["setup-pterodactyl-dirs.service"];
    after = ["setup-pterodactyl-dirs.service"];
  };

  # TODO: systemd-tmpfiles
  systemd.services.setup-pterodactyl-dirs = {
    script = ''
      mkdir -p /persist/ptero/mysql
      chown 84:84 /persist/ptero/mysql
      chmod 700 /persist/ptero/mysql

      mkdir -p /persist/ptero/wings
      chown 988:988 /persist/ptero/wings
      chmod 700 /persist/ptero/wings

      mkdir -p /persist/ptero/wings-configs
      chown 988:988 /persist/ptero/wings-configs
      chmod 700 /persist/ptero/wings-configs

      mkdir -p /persist/ptero/docker
      chmod 710 /persist/ptero/docker

      mkdir -p /persist/ptero/panel
    '';
    serviceConfig.RemainAfterExit = true;
  };

  age.secrets.pterodactyl-panel-passwords.file = ../../secrets/intpass/pterodactyl-panel.age;
  age.secrets.pterodactyl-redis-password.file = ../../secrets/intpass/pterodactyl-redis.age;

  containers.pterodactyl = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    hostBridge = "wgavbr";
    localAddress = "10.8.8.100/24";

    extraFlags = ["--system-call-filter=@keyring" "--system-call-filter=bpf"];

    bindMounts = {
      "/var/lib/mysql/" = {
        hostPath = "/persist/ptero/mysql";
        isReadOnly = false;
      };
      "/srv/pterodactyl/" = {
        hostPath = "/persist/ptero/panel";
        isReadOnly = false;
      };
      "/var/lib/pterodactyl/" = {
        hostPath = "/persist/ptero/wings";
        isReadOnly = false;
      };
      "/etc/pterodactyl/" = {
        hostPath = "/persist/ptero/wings-configs";
        isReadOnly = false;
      };
      "/var/lib/docker/" = {
        hostPath = "/persist/ptero/docker";
        isReadOnly = false;
      };
      "/run/panel.env".hostPath = config.age.secrets.pterodactyl-panel-passwords.path;
      "/run/redis-pass".hostPath = config.age.secrets.pterodactyl-redis-password.path;
    };

    config = {
      config,
      pkgs,
      ...
    }: {
      system.stateVersion = "22.11";

      networking = {
        defaultGateway = {
          address = "10.8.8.1";
          interface = "eth0";
        };
        firewall.enable = false;
        useHostResolvConf = false;
        nameservers = ["9.9.9.9" "8.8.8.8" "1.1.1.1" "77.88.8.8"];
      };
      services.resolved.enable = true;

      virtualisation.oci-containers = {
        backend = "docker";
        containers = {
          panel = {
            image = "ghcr.io/pterodactyl/panel:v1.11.2";
            volumes = [
              "/srv/pterodactyl/var/:/app/var/"
              "/srv/pterodactyl/logs/:/app/storage/logs"
            ];
            extraOptions = ["--network=host"];
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
            environmentFiles = ["/run/panel.env"];
          };
          wings = {
            image = "ghcr.io/averyanalex/wings:v1.11.0-np";
            volumes = [
              "/var/run/docker.sock:/var/run/docker.sock"
              "/var/lib/docker/containers/:/var/lib/docker/containers/"
              "/etc/pterodactyl/:/etc/pterodactyl/"
              "/var/lib/pterodactyl/:/var/lib/pterodactyl/"
              "/var/log/pterodactyl/:/var/log/pterodactyl/"
              "/tmp/pterodactyl/:/tmp/pterodactyl/"
            ];
            extraOptions = ["--network=host"];
            environment = {
              TZ = "Europe/Moscow";
              WINGS_UID = "988";
              WINGS_GID = "988";
              WINGS_USERNAME = "pterodactyl";
            };
          };
        };
      };

      virtualisation.docker = {
        enable = true;
        autoPrune = {
          enable = true;
          flags = ["--all"];
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
        settings = {
          mysqld = {
            max_connections = 512;
          };
        };
        ensureDatabases = ["panel"];
        ensureUsers = [
          {
            name = "panel";
            ensurePermissions = {
              "panel.*" = "ALL PRIVILEGES";
            };
          }
        ];
      };
    };
  };
}
