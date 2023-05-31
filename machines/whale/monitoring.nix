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
        http_addr = "10.5.3.20";
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

  systemd.services.grafana = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  services.postgresql = {
    ensureDatabases = ["grafana"];
    ensureUsers = [
      {
        name = "grafana";
        ensurePermissions = {
          "DATABASE grafana" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [3729];

  services.prometheus = {
    enable = true;

    listenAddress = "127.0.0.1";
    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "1m";
        static_configs = [
          {
            targets = ["localhost:9090"];
          }
        ];
      }
      {
        job_name = "node";
        scrape_interval = "1m";
        static_configs = [
          {
            targets = [
              "alligator:9100"
              "hamster:9100"
              "hawk:9100"
              "whale:9100"
            ];
          }
        ];
      }
      {
        job_name = "nginx";
        scrape_interval = "1m";
        static_configs = [
          {
            targets = [
              "hawk:9113"
            ];
          }
        ];
      }
      {
        job_name = "postgres";
        scrape_interval = "1m";
        static_configs = [
          {
            targets = [
              "whale:9187"
            ];
          }
        ];
      }
      {
        job_name = "wireguard";
        scrape_interval = "1m";
        static_configs = [
          {
            targets = [
              "hawk:9586"
            ];
          }
        ];
      }
    ];
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/prometheus2";
      user = "prometheus";
      group = "prometheus";
      mode = "u=rwx,g=,o=";
    }
    {
      directory = "/var/lib/grafana";
      user = "grafana";
      group = "grafana";
      mode = "u=rwx,g=,o=";
    }
  ];
}
