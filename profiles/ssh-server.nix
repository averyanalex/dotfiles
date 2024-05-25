{pkgs, ...}: {
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = [pkgs.mosh];
  networking.firewall = {
    interfaces."nebula.averyan".allowedTCPPorts = [22];
    allowedUDPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];
  };
}
