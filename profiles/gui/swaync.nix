{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.unstable.swaynotificationcenter ];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=swaync
      bind=SUPER,N,exec,swaync-client -t -sw
    '';
  };
}
