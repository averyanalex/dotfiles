{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.alex = {
    home.packages = [
      (pkgs.rustPlatform.buildRustPackage
        rec {
          pname = "swayosd";
          version = "875c943e9a6c9ae2cc2dbb7cbee8812f689db665";

          src = pkgs.fetchFromGitHub {
            owner = "averyanalex";
            repo = pname;
            rev = version;
            sha256 = "szpy4NIMw6S/HqhoLH1LEx9yohFQXmtbz9XJd47P9XM=";
          };

          cargoSha256 = "hXKAoXnTJAzFcWSEpqrythXPunt3lcrySXB13R7hSzM=";

          nativeBuildInputs = with pkgs; [pkg-config];
          buildInputs = with pkgs; [glib atk gtk3 gtk-layer-shell pulseaudio];

          meta = with lib; {
            description = "A GTK based on screen display for keyboard shortcuts like caps-lock and volume";
            homepage = "https://github.com/ErikReider/SwayOSD";
            license = licenses.gpl3;
            # maintainers = with maintainers; [ doronbehar ];
          };
        })
    ];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=swayosd
      bindle=, XF86AudioRaiseVolume, exec, swayosd --output-volume raise
      bindle=, XF86AudioLowerVolume, exec, swayosd --output-volume lower

      bindle=SHIFT, XF86AudioRaiseVolume, exec, swayosd --input-volume raise
      bindle=SHIFT, XF86AudioLowerVolume, exec, swayosd --input-volume lower

      bind=, XF86AudioMute, exec, swayosd --output-volume mute-toggle
      bind=, XF86AudioMicMute, exec, swayosd --input-volume mute-toggle

      binde=, XF86MonBrightnessUp, exec, light -A 10
      binde=, XF86MonBrightnessDown, exec, light -U 10

      bindr=, Caps_Lock, exec, swayosd --caps-lock
    '';
    # binde=, XF86MonBrightnessUp, exec, swayosd --brightness raise
    # binde=, XF86MonBrightnessDown, exec, swayosd --brightness lower
  };
}
