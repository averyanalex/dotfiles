{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  environment.systemPackages = [ pkgs.mosh ];
  networking.firewall.allowedUDPPortRanges = [{ from = 60000; to = 61000; }];

  persist.state.dirs = [ "/etc/ssh" ];

  # hack for agenix
  fileSystems."/etc/ssh" = {
    depends = [ "/persist" ];
    neededForBoot = true;
  };
}
