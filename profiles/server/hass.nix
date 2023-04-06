{inputs, ...}: let
  overlay-hass = final: prev: {
    home-assistant = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.home-assistant;
  };
in {
  nixpkgs.overlays = [overlay-hass];
  disabledModules = [
    "services/home-automation/home-assistant.nix"
  ];
  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/home-automation/home-assistant.nix")
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "airvisual"
      "co2signal"
      "esphome"
      "met"
      "roomba"
      "utility_meter"
      "zha"
    ];
    extraPackages = python3Packages:
      with python3Packages; [
        aiogithubapi
        psycopg2
        securetar
      ];
    config = {
      default_config = {};
      http = {
        server_host = "10.5.3.20";
        trusted_proxies = ["10.5.3.12"];
        use_x_forwarded_for = true;
      };
      binary_sensor = [
        {
          platform = "ping";
          host = "192.168.3.60";
          name = "PC Status";
          count = 2;
          scan_interval = 5;
        }
      ];
      switch = [
        {
          platform = "template";
          switches.pc = {
            unique_id = "pc";
            friendly_name = "PC";
            value_template = "{{ is_state('binary_sensor.pc_status', 'on') }}";
            availability_template = "{{ not is_state('button.press_pc_power_button', 'unavailable') }}";
            turn_on = [
              {
                condition = "state";
                entity_id = "binary_sensor.pc_status";
                state = "off";
              }
              {
                service = "button.press";
                target.entity_id = "button.press_pc_power_button";
              }
            ];
            turn_off = [
              {
                condition = "state";
                entity_id = "binary_sensor.pc_status";
                state = "on";
              }
              {
                service = "button.press";
                target.entity_id = "button.press_pc_power_button";
              }
            ];
          };
        }
      ];
      recorder.db_url = "postgresql://@/hass";
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      script = "!include scripts.yaml";
    };
  };

  systemd.services.home-assistant = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  users.users.hass.extraGroups = ["dialout"];

  virtualisation.oci-containers = {
    containers = {
      esphome = {
        image = "esphome/esphome:2023.3.2";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/var/lib/esphome:/config"
        ];
        extraOptions = ["--network=host" "--privileged"];
        environment = {
          ESPHOME_DASHBOARD_USE_PING = "true";
          TZ = "Europe/Moscow";
        };
      };
    };
  };

  systemd.services."podman-esphome".serviceConfig.RestartSec = "10s";

  services.postgresql = {
    ensureDatabases = ["hass"];
    ensureUsers = [
      {
        name = "hass";
        ensurePermissions = {
          "DATABASE hass" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  persist.state.dirs = [
    {
      directory = "/var/lib/hass";
      user = "hass";
      group = "hass";
      mode = "u=rwx,g=,o=";
    }
    {
      directory = "/var/lib/esphome";
      mode = "u=rwx,g=,o=";
    }
  ];

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [8123 6052];
}
