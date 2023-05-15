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
          version = "5c2176ae6a01a18fdc2b0f5d5f593737b5765914";

          src = pkgs.fetchFromGitHub {
            owner = "ErikReider";
            repo = pname;
            rev = version;
            hash = "sha256-rh42J6LWgNPOWYLaIwocU1JtQnA5P1jocN3ywVOfYoc=";
          };

          cargoSha256 = "f/MaNADm/jkEqofd5ixQBcsPr3mjt4qTMRrr0A0J5sI=";

          nativeBuildInputs = with pkgs; [pkg-config];
          buildInputs = with pkgs; [glib atk gtk3 gtk-layer-shell pulseaudio];

          meta = with lib; {
            description = "A GTK based on screen display for keyboard shortcuts like caps-lock and volume";
            homepage = "https://github.com/ErikReider/SwayOSD";
            license = licenses.gpl3;
          };
        })
    ];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=swayosd --max-volume 150
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
