{pkgs, ...}: {
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  services.printing.drivers = with pkgs; [gutenprint hplipWithPlugin];

  environment.systemPackages = with pkgs; [
    gnome.simple-scan
  ];
}
