{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  home-manager.users.alex = {
    home.packages = [
      inputs.hyprwm-contrib.packages.${pkgs.hostPlatform.system}.grimblast
    ];
    programs.waybar = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.hostPlatform.system}.waybar-hyprland;
      style = ''
        * {
            border:        none;
            border-radius: 0;
            font-family:   Sans;
            font-size:     15px;
            box-shadow:    none;
            text-shadow:   none;
            transition-duration: 0s;
        }

        window {
            color:      rgba(217, 216, 216, 1);
            background: rgba(35, 31, 32, 0.00);
        }

        window#waybar.solo {
            color:      rgba(217, 216, 216, 1);
            background: rgba(35, 31, 32, 0.85);
        }

        #workspaces {
            margin: 0 5px;
        }

        #workspaces button {
            padding:    0 5px;
            color:      rgba(217, 216, 216, 0.4);
        }

        #workspaces button.visible {
            color:      rgba(217, 216, 216, 1);
        }

        #workspaces button.focused {
            border-top: 3px solid rgba(217, 216, 216, 1);
            border-bottom: 3px solid rgba(217, 216, 216, 0);
        }

        #workspaces button.urgent {
            color:      rgba(238, 46, 36, 1);
        }

        #mode, #battery, #cpu, #memory, #network, #pulseaudio, #idle_inhibitor, #backlight, #custom-storage, #custom-spotify, #custom-weather, #custom-mail {
            margin:     0px 6px 0px 10px;
            min-width:  25px;
        }

        #clock {
            margin:     0px 16px 0px 10px;
            min-width:  140px;
        }

        #battery.warning {
           color:       rgba(255, 210, 4, 1);
        }

        #battery.critical {
            color:      rgba(238, 46, 36, 1);
        }

        #battery.charging {
            color:      rgba(217, 216, 216, 1);
        }

        #custom-storage.warning {
            color:      rgba(255, 210, 4, 1);
        }

        #custom-storage.critical {
            color:      rgba(238, 46, 36, 1);
        }
      '';
      settings = [
        {
          height = 30;
          layer = "top";
          # position = "bottom";
          tray = {spacing = 10;};
          modules-left = [
            "tray"
            "mpd"
            "wlr/workspaces"
          ];
          modules-center = [
            "cpu"
            "memory"
            "disk"
          ];
          modules-right = [
            "pulseaudio"
            "backlight"
            (lib.optionalString (config.networking.hostName != "alligator") "upower")
            "network"
            "clock"
          ];
          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%d.%m.%Y}";
            tooltip-format = "{:%H:%M | %d.%m.%Y}";
          };
          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };
          memory = {format = "{}% ";};
          # disk = {
          #   format = "{percentage_free}% 🖴";
          #   path = "/persist";
          # };
          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ipaddr}/{cidr} ";
            tooltip-format = "{ifname} via {gwaddr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = ["" "" ""];
          };
          "wlr/workspaces" = {
            "format" = "{icon}";
            "on-scroll-up" = "hyprctl dispatch workspace e+1";
            "on-scroll-down" = "hyprctl dispatch workspace e-1";
            "on-click" = "activate";
          };
        }
      ];
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
