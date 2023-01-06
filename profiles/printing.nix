{ pkgs, ... }:
{
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  environment.systemPackages = with pkgs; [
    gnome.simple-scan
  ];
}
