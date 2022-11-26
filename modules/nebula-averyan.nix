{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.networking.nebula-averyan;
in
{
  options = {
    networking.nebula-averyan = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable averyan nebula network.";
      };
      isLighthouse = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to configure this node as lighthouse.";
      };
      firewall = {
        outbound = mkOption {
          type = types.listOf types.attrs;
          default = [{ port = "any"; proto = "any"; host = "any"; }];
          description = "Firewall rules for outbound traffic.";
          example = [ ];
        };
        inbound = mkOption {
          type = types.listOf types.attrs;
          default = [{ port = "any"; proto = "any"; host = "any"; }];
          description = "Firewall rules for inbound traffic.";
          example = [ ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    age.secrets.nebula-averyan-ca.file = ../secrets/nebula/ca-crt.age;
    age.secrets.nebula-averyan-key.file = ../secrets/nebula + "/${config.networking.hostName}-key.age";
    age.secrets.nebula-averyan-crt.file = ../secrets/nebula + "/${config.networking.hostName}-crt.age";

    services.nebula.networks.averyan = {
      package = pkgs.unstable.nebula;

      key = config.age.secrets.nebula-averyan-key.path;
      cert = config.age.secrets.nebula-averyan-crt.path;
      ca = config.age.secrets.nebula-averyan-ca.path;

      listen.port = 4243;
      isLighthouse = cfg.isLighthouse;

      lighthouses = mkIf (!cfg.isLighthouse) [ "10.5.3.10" ];
      staticHostMap = {
        "10.5.3.10" = [
          "185.112.83.178:4243"
        ];
      };

      settings = {
        lighthouse = {
          remote_allow_list = {
            "10.3.7.0/24" = false;
          };
        };
        punchy = {
          punch = true;
          respond = true;
        };
        relay = {
          am_relay = cfg.isLighthouse;
          relays = mkIf (!cfg.isLighthouse) [ "10.5.3.10" ];
        };
      };

      firewall = cfg.firewall;
    };
  };
}
