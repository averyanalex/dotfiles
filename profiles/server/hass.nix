{pkgs, ...}: let
  # overlay-hass = final: prev: {
  #   home-assistant = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.home-assistant;
  # };
  dockerImageAMD64 = pkgs.dockerTools.pullImage {
    imageName = "esphome/esphome";
    finalImageTag = "latest";
    imageDigest = "sha256:40d3c269cafeebce030e64f58908bfe74cb4a1a81ccc2a23ff78a0a070fe63d7";
    sha256 = "hLy531wi5zkIDqdNjHVEjjyBTeazQFolFVPezf4FohQ=";
  };
  dockerImageARM64 = pkgs.dockerTools.pullImage {
    imageName = "esphome/esphome";
    finalImageTag = "latest";
    imageDigest = "sha256:39edbb81b0591d8293c80fa938d3543603f842af9a744a483af75dcde74fe7bf";
    sha256 = "3aGEEeVaLU97PmmopqDzoDpJiATYg8xGD5TpGmGnfbU=";
  };
  dockerImage =
    if pkgs.hostPlatform.system == "aarch64-linux"
    then dockerImageARM64
    else dockerImageAMD64;
in {
  # nixpkgs.overlays = [overlay-hass];
  # disabledModules = [
  #   "services/home-automation/home-assistant.nix"
  # ];
  # imports = [
  #   (inputs.nixpkgs-unstable + "/nixos/modules/services/home-automation/home-assistant.nix")
  # ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
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
      "ping"
    ];
    extraPackages = python3Packages:
      with python3Packages; [
        aiogithubapi
        google-api-python-client
        moonraker-api
        protobuf
        psycopg2
        securetar
        ulid-transform
        # getmac
      ];
    config = {
      default_config = {};
      http = {
        trusted_proxies = ["10.57.1.10" "::1" "127.0.0.1"];
        use_x_forwarded_for = true;
      };
      recorder.db_url = "postgresql://@/hass";
      automation = "!include automations.yaml";
      scene = "!include scenes.yaml";
      script = "!include scripts.yaml";
      notify = [
        {
          name = "ntfy";
          platform = "rest";
          method = "POST_JSON";
          data.topic = "!secret ntfy_topic";
          title_param_name = "title";
          message_param_name = "message";
          resource = "https://ntfy.averyan.ru";
        }
      ];
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
        image = "esphome/esphome";
        imageFile = dockerImage;
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
  # systemd.services."podman-esphome".after = ["network-online.target"];
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
        ensureDBOwnership = true;
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
