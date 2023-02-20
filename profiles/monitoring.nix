{ config, lib, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "buddyinfo"
      "ksmd"
      "mountstats"
      "processes"
      "qdisc"
      "systemd"
      "tcpstat"
    ];
  };

  networking.firewall.interfaces."nebula.averyan".allowedTCPPorts = [ 9100 ];
}
