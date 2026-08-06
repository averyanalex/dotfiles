{
  pkgs,
  lib,
  ...
}:
let
  package = pkgs.nginx;
in
{
  options = {
    services.nginx.virtualHosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          config = {
            # quic = true;
            forceSSL = true;
          };
        }
      );
    };
  };

  config = {
    services.nginx = {
      enable = true;
      inherit package;

      clientMaxBodySize = "50000M";

      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      recommendedGzipSettings = true;
      recommendedBrotliSettings = true;
      # recommendedZstdSettings = true;

      # enableQuicBPF = true;

      appendHttpConfig = ''
        # HSTS
        map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Disable QUIC
        add_header Alt-Svc "";

        proxy_buffering off;
      '';

      virtualHosts."_" = {
        default = true;
        rejectSSL = true;
        # quic = lib.mkForce false;
        forceSSL = lib.mkForce false;
        locations."/".extraConfig = ''
          return 404;
        '';
      };
    };

    systemd.services.nginx.serviceConfig.MemoryMax = "4G";

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
      interfaces."nebula.averyan".allowedTCPPorts = [ 9114 ];
    };

    # services.prometheus.exporters.nginx.enable = true;
  };
}
