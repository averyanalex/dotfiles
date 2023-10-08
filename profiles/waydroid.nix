{
  virtualisation.waydroid.enable = true;

  networking.nft-firewall = {
    extraFilterForwardRules = [
      ''iifname "waydroid0" counter accept''
      ''oifname "waydroid0" ct state { established, related } counter accept''
    ];
    extraNatPostroutingRules = [
      ''iifname "waydroid0" masquerade''
    ];
  };

  persist.state.dirs = ["/var/lib/waydroid"];
  persist.state.homeDirs = [".local/share/waydroid"];
}
