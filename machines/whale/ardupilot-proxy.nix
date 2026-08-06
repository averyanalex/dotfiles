{ ... }:
let
  mkProxy = upstreamName: upstreamHost: {
    enableACME = true;
    acmeRoot = null;

    locations."/" = {
      proxyPass = "https://${upstreamName}";
      proxyWebsockets = true;
      recommendedProxySettings = false;

      extraConfig = ''
        proxy_ssl_server_name on;
        proxy_ssl_name ${upstreamHost};
        proxy_set_header Host ${upstreamHost};

        proxy_hide_header Access-Control-Allow-Origin;
        proxy_hide_header Access-Control-Allow-Methods;
        proxy_hide_header Access-Control-Allow-Headers;

        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "*" always;
        add_header Access-Control-Allow-Headers "*" always;

        if ($request_method = OPTIONS) {
          return 204;
        }
      '';
    };
  };
in
{
  services.nginx = {
    resolver = {
      addresses = [ "95.165.105.90" ];
      valid = "5m";
      ipv6 = false;
    };

    upstreams = {
      "ardupilot-autotest" = {
        servers."autotest.ardupilot.org:443".resolve = true;
        extraConfig = "zone ardupilot-autotest 64k;";
      };
      "ardupilot-firmware" = {
        servers."firmware.ardupilot.org:443".resolve = true;
        extraConfig = "zone ardupilot-firmware 64k;";
      };
    };

    virtualHosts = {
      "ardupilot-autotest.averylex.dev" = mkProxy "ardupilot-autotest" "autotest.ardupilot.org";
      "ardupilot-firmware.averylex.dev" = mkProxy "ardupilot-firmware" "firmware.ardupilot.org";
    };
  };

}
