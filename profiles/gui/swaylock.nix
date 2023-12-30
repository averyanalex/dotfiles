{
  lib,
  config,
  pkgs,
  ...
}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
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

    services.swayidle = {
      enable = true;
      events =
        [
          {
            event = "lock";
            command = "swaylock";
          }
        ]
        ++ lib.optionals (config.networking.hostName
          != "alligator") [
          {
            event = "before-sleep";
            command = "swaylock";
          }
        ];
      timeouts =
        [
          {
            timeout = 300;
            command = "brillo -u 300000 -S 10";
            resumeCommand = "brillo -u 100000 -S 65";
          }
          {
            timeout = 360;
            command = "swaymsg \"output * dpms standby\"";
            resumeCommand = "swaymsg \"output * dpms on\"";
          }
        ]
        ++ lib.optionals (config.networking.hostName
          != "alligator") [
          {
            timeout = 330;
            command = "swaylock --grace 40";
          }
        ];
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
