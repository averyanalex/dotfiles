{pkgs, ...}: {
  services.opensnitch = {
    enable = true;
    settings = {
      Firewall = "nftables";
      DefaultDuration = "15m";
      DefaultAction = "allow";
      ProcMonitorMethod = "ebpf";
    };
  };

  hm.services.opensnitch-ui.enable = true;
  hm.home.packages = [pkgs.opensnitch-ui];
}
