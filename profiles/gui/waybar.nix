{ inputs, pkgs, ... }:
{
  home-manager.users.alex = {
    programs.waybar = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.hostPlatform.system}.waybar-hyprland;
      # settings = [{
      #   modules-left = [
      #     "tray"
      #     "mpd"
      #     "wlr/workspaces"
      #   ];
      #   modules-center = [
      #     "cpu"
      #     "memory"
      #     "disk"
      #   ];
      #   modules-right = [
      #     "pulseaudio"
      #     "backlight"
      #     "upower"
      #     "network"
      #     "clock"
      #   ];
      # }];
    };
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=waybar
    '';
  };
}
