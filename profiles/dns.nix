{pkgs, ...}: {
  networking = {
    nameservers = ["9.9.9.9" "8.8.8.8" "1.1.1.1" "77.88.8.8"];
    search = ["n.averyan.ru"];
  };
  services.resolved = {
    enable = true;
    dnssec = "false";
  };
}
