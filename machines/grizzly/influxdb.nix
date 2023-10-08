{config, ...}: {
  services.influxdb2 = {
    enable = true;
    provision = {
      enable = true;
      initialSetup = {
        organization = "main";
        bucket = "example";
        passwordFile = config.age.secrets.influxdb-admin.path;
        tokenFile = config.age.secrets.influxdb-admin-token.path;
      };
      organizations.main = {
        buckets = {
          # metrics = {};
          prices = {};
          spreads = {};
        };
      };
    };
  };

  age.secrets.influxdb-admin = {
    file = ../../secrets/intpass/grizzly-influxdb-admin.age;
    owner = "influxdb2";
    group = "influxdb2";
  };

  age.secrets.influxdb-admin-token = {
    file = ../../secrets/intpass/grizzly-influxdb-admin-token.age;
    owner = "influxdb2";
    group = "influxdb2";
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [8086];

  fileSystems."/var/lib/influxdb2" = {
    device = "/dev/sdf1";
    fsType = "ext4";
    autoResize = true;
  };
}
