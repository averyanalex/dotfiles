{
  lib,
  config,
  pkgs,
  ...
}: let
  # fancylock = pkgs.writeShellScript "sway-fancylock" ''
  #   swaylock \
  #     --daemonize
  #     --screenshots \
  #     --clock \
  #     --indicator \
  #     --indicator-radius 100 \
  #     --indicator-thickness 7 \
  #     --effect-blur 9x15 \
  #     --effect-vignette 0.5:0.5 \
  #     --ring-color bb00cc \
  #     --key-hl-color 880033 \
  #     --line-color 00000000 \
  #     --inside-color 00000088 \
  #     --separator-color 00000000 \
  #     --fade-in 1.5 \
  #     "$@"
  # '';
  idlehandler = pkgs.writeShellScriptBin "sway-idlehandler" ''
    swayidle -w ${lib.optionalString (config.networking.hostName != "alligator") "timeout 300 'swaylock --grace 70' before-sleep 'swaylock'"} timeout 360 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
  '';
in {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      idlehandler
      swayidle
    ];

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        daemonize = true;
        screenshots = true;
        clock = true;
        indicator = true;
        indicator-radius = 100;
        indicator-thickness = 7;
        effect-blur = "9x15";
        effect-vignette = "0.5:0.5";
        fade-in = 1.5;
      };
    };

    # wayland.windowManager.sway = {
    #   config.keybindings =
    #     let
    #       mod = config.home-manager.users.alex.wayland.windowManager.sway.config.modifier;
    #     in
    #     lib.mkOptionDefault {
    #       # "${mod}+L" = "${fancylock}";
    #     };
    #   extraConfig = ''
    #     exec ${idlehandler}
    #   '';
    # };
  };

  security.pam.services.swaylock = {};
}
