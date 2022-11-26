{ lib, config, pkgs, ... }:

let
  fancylock = pkgs.writeShellScript "sway-fancylock" ''
    swaylock \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 100 \
      --indicator-thickness 7 \
      --effect-blur 9x15 \
      --effect-vignette 0.5:0.5 \
      --ring-color bb00cc \
      --key-hl-color 880033 \
      --line-color 00000000 \
      --inside-color 00000088 \
      --separator-color 00000000 \
      --fade-in 1.5 \
      "$@"
  '';
  idlehandler = pkgs.writeShellScript "sway-idlehandler" ''
    swayidle -w timeout 300 '${fancylock} --grace 60'
  '';
in
{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      swayidle
      swaylock-effects
    ];

    wayland.windowManager.sway = {
      config.keybindings =
        let
          mod = config.home-manager.users.alex.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          # "${mod}+L" = "${fancylock}";
        };
      extraConfig = ''
        exec ${idlehandler}
      '';
    };
  };

  security.pam.services.swaylock = { };
}
