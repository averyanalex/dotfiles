{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    hostKeys = [
      {
        bits = 4096;
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  environment.systemPackages = [ pkgs.mosh ];
  networking.firewall.allowedUDPPortRanges = [{ from = 60000; to = 61000; }];
}
