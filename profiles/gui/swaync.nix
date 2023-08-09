{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.swaynotificationcenter];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=swaync
      bind=SUPER,N,exec,swaync-client -t -sw
    '';
  };
}
