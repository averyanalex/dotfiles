{ inputs, ... }:
let
  overlay-hass = final: prev: {
    home-assistant = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.home-assistant;
  };
in
{
  nixpkgs.overlays = [ overlay-hass ];
  disabledModules = [
    "services/home-automation/home-assistant.nix"
  ];
  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/home-automation/home-assistant.nix")
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "met"
      "radio_browser"
    ];
    extraPackages = python3Packages: with python3Packages; [
      securetar
      psycopg2
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
      http = {
        server_host = "10.5.3.20";
        trusted_proxies = [ "10.5.3.12" ];
        use_x_forwarded_for = true;
      };
      recorder.db_url = "postgresql://@/hass";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "hass" ];
    ensureUsers = [{
      name = "hass";
      ensurePermissions = {
        "DATABASE hass" = "ALL PRIVILEGES";
      };
    }];
  };

  persist.state.dirs = [{ directory = "/var/lib/hass"; user = "hass"; group = "hass"; mode = "u=rwx,g=,o="; }];

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [ 8123 ];
}
