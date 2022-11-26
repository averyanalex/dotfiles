{ lib, pkgs, config, ... }:

{
  imports = [
    ./swaylock.nix
    ./wm.nix
  ];

  home-manager.users.alex = {
    home.packages = with pkgs; [
      swayidle
      swaylock-effects
    ];

    programs.bash.enable = true;
    programs.bash.profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        sway
      fi
    '';

    wayland.windowManager.sway = {
      # TODO: random wallpaper from ~/Pictures/Wallpapers/3440x1440
      enable = true;
      systemdIntegration = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        export NIXOS_OZONE_WL=1

        export _JAVA_AWT_WM_NONREPARENTING=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_QPA_PLATFORM=wayland
      '';
      config = {
        input = {
          "*" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:alt_shift_toggle";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
            dwt = "disabled";
          };
        };
        bars = [ ];
        keybindings =
          let
            cfg = config.home-manager.users.alex.wayland.windowManager.sway.config;
          in
          lib.mkOptionDefault {
            "${cfg.modifier}+q" = "kill";

            # TODO: clipboard history
            # "${cfg.modifier}+h" = "exec clipman pick -t rofi";
            # TODO: run in terminal
            # "${cfg.modifier}+Shift+d" = "exec rofi -show run -run-shell-command \'{terminal} -e zsh -ic \"{cmd} && read\"\'";

            "Mod4+m" = "exec rofi -show emoji";

            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";

            "XF86MonBrightnessDown" = "exec light -U 10";
            "XF86MonBrightnessUp" = "exec light -A 10";

            "Print" = ''exec grim -g "$(slurp -d)" - | tee ~/Pictures/Screenshots/$(date +%H_%M_%S-%d_%m_%Y).png | wl-copy -t image/png'';
            "Shift+Print" = ''exec grim - | tee ~/Pictures/Screenshots/$(date +%H_%M_%S-%d_%m_%Y).png | wl-copy -t image/png'';
            # TODO: screenshot focused window
            # "Mod1+Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | tee ~/Pictures/Screenshots/$(date +%H_%M_%S-%d_%m_%Y).png | wl-copy -t image/png'';
            # TODO: setup flameshot
          };
        terminal = "alacritty";
        menu = "rofi -show drun";
        modifier = "Mod4"; # Super
      };
      extraConfig = ''
        # polkit
        exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

        # vnc
        # exec ${pkgs.unstable.wayvnc}/bin/wayvnc --gpu

        # clipboard
        # exec clipman restore
        # exec wl-paste -t text --watch clipman store

        # STYLING
        gaps inner 5
        gaps outer 5
        default_border pixel 1
        smart_borders on

        for_window [shell="xdg_shell"] title_format "%title (%app_id)"
        for_window [shell="x_wayland"] title_format "%class - %title"

        exec waybar

        # AUTOSTART
        # exec telegram-desktop -startintray
        # exec element-desktop --hidden
      '';
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = [ pkgs.rofi-emoji ];
      terminal = "alacritty";
      extraConfig = {
        modi = "drun,run,emoji,ssh";
        show-icons = true;
      };
    };

    programs.waybar = {
      enable = true;
      # settings = {
      #   mainBar = {
      #     "network" = {
      #       interval = 10;
      #       format = "{ifname}";
      #       format-wifi = "{essid} ({signalStrength}%)";
      #       format-ethernet = "{ifname}";
      #       format-disconnected = "SUS";
      #       tooltip-format = "{ifname}";
      #       tooltip-format-wifi = "{essid} ({signalStrength}%)";
      #       tooltip-format-ethernet = "{ifname}";
      #       tooltip-format-disconnected = "Disconnected";
      #     };
      #   };
      # };
    };
  };
}
