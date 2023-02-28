{ config, ... }:
{
  age.secrets.photoprism.file = ../../secrets/intpass/photoprism.age;

  systemd.services."podman-photoprism" = {
    requires = [ "setup-photoprism-dirs.service" "mysql.service" ];
    after = [ "setup-photoprism-dirs.service" "mysql.service" ];
    serviceConfig.RestartSec = "10s";
  };

  systemd.services.setup-photoprism-dirs = {
    script = ''
      mkdir -p /persist/var/lib/photoprism
      chown 1000:100 /persist/var/lib/photoprism
      chmod 700 /persist/var/lib/photoprism
    '';
    serviceConfig.RemainAfterExit = true;
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [ 2342 ];

  virtualisation.oci-containers = {
    containers = {
      photoprism = {
        image = "photoprism/photoprism:221118-jammy";
        volumes = [
          "/tank/Галерея:/photoprism/originals"
          "/tank/Импорт:/photoprism/import"
          "/persist/var/lib/photoprism:/photoprism/storage"
        ];
        extraOptions = [ "--network=host" ];
        environment = {
          PHOTOPRISM_ADMIN_USER = "admin";
          PHOTOPRISM_AUTH_MODE = "password";
          PHOTOPRISM_SITE_URL = "https://prism.averyan.ru/";
          PHOTOPRISM_ORIGINALS_LIMIT = "5000";
          PHOTOPRISM_HTTP_COMPRESSION = "none";
          PHOTOPRISM_LOG_LEVEL = "info";
          PHOTOPRISM_READONLY = "false";
          PHOTOPRISM_EXPERIMENTAL = "false";
          PHOTOPRISM_DISABLE_CHOWN = "false";
          PHOTOPRISM_DISABLE_WEBDAV = "false";
          PHOTOPRISM_DISABLE_SETTINGS = "false";
          PHOTOPRISM_DISABLE_TENSORFLOW = "false";
          PHOTOPRISM_DISABLE_FACES = "false";
          PHOTOPRISM_DISABLE_CLASSIFICATION = "false";
          PHOTOPRISM_DISABLE_RAW = "false";
          PHOTOPRISM_RAW_PRESETS = "false";
          PHOTOPRISM_JPEG_QUALITY = "85";
          PHOTOPRISM_DETECT_NSFW = "true";
          PHOTOPRISM_UPLOAD_NSFW = "true";
          PHOTOPRISM_DATABASE_DRIVER = "mysql";
          PHOTOPRISM_DATABASE_SERVER = "127.0.0.1:3306";
          PHOTOPRISM_DATABASE_NAME = "photoprism";
          PHOTOPRISM_DATABASE_USER = "photoprism";
          PHOTOPRISM_SITE_CAPTION = "AI-Powered Photos App";
          PHOTOPRISM_SITE_DESCRIPTION = "";
          PHOTOPRISM_SITE_AUTHOR = "";
          ## Run/install on first startup (options: update https gpu tensorflow davfs clitools clean):
          # PHOTOPRISM_INIT: "https gpu tensorflow"
          ## Hardware Video Transcoding:
          PHOTOPRISM_FFMPEG_ENCODER = "software";
          # PHOTOPRISM_FFMPEG_BITRATE: "32"              # FFmpeg encoding bitrate limit in Mbit/s (default: 50)
          ## Run as a non-root user after initialization (supported: 0, 33, 50-99, 500-600, and 900-1200):
          PHOTOPRISM_UID = "1000";
          PHOTOPRISM_GID = "100";
          # PHOTOPRISM_UMASK: 0000
        };
        environmentFiles = [ config.age.secrets.photoprism.path ];
      };
    };
  };

  services.mysql = {
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [{
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    }];
  };
}
