{pkgs, ...}: {
  virtualisation.averyan-waydroid = {
    enable = true;
    package = pkgs.waydroid;
  };

  persist.state.dirs = ["/var/lib/waydroid"];
}
