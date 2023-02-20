{ lib, config, pkgs, ... }:
{
  services.grafana = {
    enable = true;

    settings = {
      database = {
        type = "postgres";
        user = "grafana";
        name = "grafana";
        host = "/run/postgresql";
      };
      server = {
        http_port = 3729;
        domain = "grafana.averyan.ru";
        rootUrl = "https://grafana.averyan.ru/";
      };
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:9090/";
        }
      ];
    };
  };

  services.postgresql = {
    ensureDatabases = [ "grafana" ];
    ensureUsers = [{
      name = "grafana";
      ensurePermissions = {
        "DATABASE grafana" = "ALL PRIVILEGES";
      };
    }];
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [ 3729 ];

  services.prometheus = {
    enable = true;

    listenAddress = "127.0.0.1";
    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "1m";
        static_configs = [{
          targets = [ "localhost:9090" ];
        }];
      }
      {
        job_name = "node";
        scrape_interval = "1m";
        static_configs = [{
          targets = [
            "alligator:9100"
            "hamster:9100"
            "hawk:9100"
            "whale:9100"
          ];
        }];
      }
    ];
  };
}
