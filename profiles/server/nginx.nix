{ pkgs, ... }:
{
  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;
    additionalModules = [ pkgs.nginxModules.brotli ];

    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
}
