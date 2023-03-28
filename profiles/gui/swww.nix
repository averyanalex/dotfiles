{ pkgs, ... }:
let
  set-random-wallpaper = pkgs.writeShellScriptBin "set-random-wallpaper" ''
    export SWWW_TRANSITION_FPS=60
    export SWWW_TRANSITION_STEP=90 # 2
    export SWWW_TRANSITION=grow
    export SWWW_TRANSITION_POS=0.8,0.9

    IMAGE=$(find ~/Pictures/Wallpapers -type f | shuf -n 1)
    swww img "$IMAGE"
  '';
  wallpaper-randomizer = pkgs.writeShellScriptBin "wallpaper-randomizer" ''
    while true; do
      ${set-random-wallpaper}/bin/set-random-wallpaper
    	sleep 300
    done
  '';
in
{
  home-manager.users.alex = {
    home.packages = [ pkgs.unstable.swww set-random-wallpaper wallpaper-randomizer ];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=swww init
      exec-once=wallpaper-randomizer
    '';
  };
}
