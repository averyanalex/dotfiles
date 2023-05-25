{pkgs, ...}: {
  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;

    clientMaxBodySize = "4G";

    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;

    statusPage = true;
  };

  users.users.nginx.extraGroups = ["acme"];

  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [443];
    interfaces."nebula.averyan".allowedTCPPorts = [9113];
  };

  services.prometheus.exporters.nginx.enable = true;
}
