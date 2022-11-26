{ pkgs, ... }:

{
  virtualisation.averyan-waydroid = {
    enable = true;
    package = pkgs.unstable.waydroid;
  };

  persist.state.dirs = [ "/var/lib/waydroid" ];
}
