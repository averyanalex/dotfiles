{
  inputs,
  # lib,
  ...
}: let
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
      "samsungtv"
      "utility_meter"
      "zha"
    ];
    extraPackages = python3Packages:
      with python3Packages; [
        aiogithubapi
        psycopg2
        securetar
        ulid-transform
        google-api-python-client
        protobuf
        # getmac
      ];
    config = {
      default_config = {};
      http = {
        trusted_proxies = ["10.5.3.12"];
        use_x_forwarded_for = true;
      };
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

  # users = {
  #   users.esphome = {
  #     isSystemUser = true;
  #     description = "ESPHome";
  #     home = "/var/lib/esphome";
  #     group = "esphome";
  #     uid = 782;
  #   };
  #   groups.esphome.gid = 782;
  # };

  users.users.hass.extraGroups = ["dialout"];

  virtualisation.oci-containers = {
    containers = {
      esphome = {
        image = "esphome/esphome:2023.5.5";
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
  systemd.services."podman-esphome".after = ["network-online.target"];
  # services.esphome = {
  #   enable = true;
  #   address = "0.0.0.0";
  # };
  # systemd.services.esphome.serviceConfig = {
  #   DynamicUser = lib.mkForce false;
  #   NoNewPrivileges = true;
  #   PrivateTmp = true;
  #   RemoveIPC = true;
  #   RestrictSUIDSGID = true;
  # };

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
      user = "esphome";
      group = "esphome";
      mode = "0750";
    }
  ];

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [8123 6052];
}
