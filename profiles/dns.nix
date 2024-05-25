{
  networking = {
    nameservers = ["95.165.105.90#dns.neutrino.su"];
    search = ["n.averyan.ru"];
  };
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "false";
  };
}
