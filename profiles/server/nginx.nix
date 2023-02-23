{ pkgs, lib, ... }:
let
  compressMimeTypes = [
    "application/atom+xml"
    "application/geo+json"
    "application/json"
    "application/ld+json"
    "application/manifest+json"
    "application/rdf+xml"
    "application/vnd.ms-fontobject"
    "application/wasm"
    "application/x-rss+xml"
    "application/x-web-app-manifest+json"
    "application/xhtml+xml"
    "application/xliff+xml"
    "application/xml"
    "font/collection"
    "font/otf"
    "font/ttf"
    "image/bmp"
    "image/svg+xml"
    "image/vnd.microsoft.icon"
    "text/cache-manifest"
    "text/calendar"
    "text/css"
    "text/csv"
    "text/html"
    "text/javascript"
    "text/markdown"
    "text/plain"
    "text/vcard"
    "text/vnd.rim.location.xloc"
    "text/vtt"
    "text/x-component"
    "text/xml"
  ];
in
{
  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;

    clientMaxBodySize = "4G";

    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    recommendedGzipSettings = true;

    # TODO: recommendedBrotliSettings = true;
    additionalModules = [ pkgs.nginxModules.brotli ];
    appendHttpConfig = ''
      brotli on;
      brotli_static on;
      brotli_comp_level 5;
      brotli_window 512k;
      brotli_min_length 256;
      brotli_types ${lib.concatStringsSep " " compressMimeTypes};
    '';

    statusPage = true;
  };

  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 443 ];
    interfaces."nebula.averyan".allowedTCPPorts = [ 9113 ];
  };

  services.prometheus.exporters.nginx.enable = true;
}
