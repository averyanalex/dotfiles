{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hpr.nix
  ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  home-manager.users.alex = {
    # colorScheme = inputs.nix-colors.colorSchemes.paraiso;

    programs.bash.enable = true;
    programs.bash.profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        Hyprland
      fi
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      recommendedEnvironment = true;
      xwayland.hidpi = true;

      extraConfig = ''
        monitor=,preferred,auto,1

        general {
          border_size=2
          gaps_in=5
          gaps_out=10
          col.active_border=0x66ee1111
          col.inactive_border=0x66333333
          resize_on_border=1
          hover_icon_on_border=0
        }

        decoration {
          rounding=7
          inactive_opacity=0.95
          blur=1
          blur_size=3
          blur_passes=1
        }

        input {
          kb_layout=us,ru
          kb_options=grp:alt_shift_toggle

          numlock_by_default=1

          touchpad {
            disable_while_typing=0
            natural_scroll=yes
          }
        }

        gestures {
            workspace_swipe=1
        }

        dwindle {
          pseudotile=1
          bind=SUPER,V,togglesplit,
        }

        misc {
          vrr=2
        }

        bind=SUPER,Q,killactive,
        bind=SUPER,F,fullscreen,0
        bind=SUPERSHIFT,E,exit,
        bind=SUPER,return,exec,alacritty
        bind=SUPER,space,togglefloating,
        bind=SUPER,left,movefocus,l
        bind=SUPER,right,movefocus,r
        bind=SUPER,up,movefocus,u
        bind=SUPER,down,movefocus,d
        bind=SUPERSHIFT,left,movewindow,l
        bind=SUPERSHIFT,right,movewindow,r
        bind=SUPERSHIFT,up,movewindow,u
        bind=SUPERSHIFT,down,movewindow,d
        bind=SUPER,1,workspace,1
        bind=SUPER,2,workspace,2
        bind=SUPER,3,workspace,3
        bind=SUPER,4,workspace,4
        bind=SUPER,5,workspace,5
        bind=SUPER,6,workspace,6
        bind=SUPER,7,workspace,7
        bind=SUPER,8,workspace,8
        bind=SUPER,9,workspace,9
        bind=SUPER,0,workspace,10
        bind=SUPERSHIFT,1,movetoworkspacesilent,1
        bind=SUPERSHIFT,2,movetoworkspacesilent,2
        bind=SUPERSHIFT,3,movetoworkspacesilent,3
        bind=SUPERSHIFT,4,movetoworkspacesilent,4
        bind=SUPERSHIFT,5,movetoworkspacesilent,5
        bind=SUPERSHIFT,6,movetoworkspacesilent,6
        bind=SUPERSHIFT,7,movetoworkspacesilent,7
        bind=SUPERSHIFT,8,movetoworkspacesilent,8
        bind=SUPERSHIFT,9,movetoworkspacesilent,9
        bind=SUPERSHIFT,0,movetoworkspacesilent,10

        exec-once=sway-idlehandler
        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
      '';
    };
  };
}
