{ pkgs, lib, ... }:
{
  home-manager.users.alex = {
    home.packages = [
      pkgs.unstable.cliphist
      pkgs.wl-clipboard
      (pkgs.rustPlatform.buildRustPackage
        rec {
          pname = "clipmon";
          version = "2e338fdc2841c3b2de9271d90fcceceda9e45d29";

          src = pkgs.fetchgit {
            url = "https://git.sr.ht/~whynothugo/clipmon";
            rev = version;
            sha256 = "bEMgJYz3e2xwMO084bmCT1oZImcmO3xH6rIsjvAxnTA=";
          };

          cargoSha256 = "nXug69YhYBuSiM6lQi0Ic4bv44SriXT/ZvvJzHxiKsw=";

          # nativeBuildInputs = with pkgs; [ pkg-config ];
          buildInputs = with pkgs; [ wayland ];

          meta = with lib; {
            description = "A clipboard monitor for Wayland";
            homepage = "https://git.sr.ht/~whynothugo/clipmon";
            license = licenses.mit;
            # maintainers = with maintainers; [ doronbehar ];
          };
        })
    ];
    wayland.windowManager.hyprland.extraConfig = ''
      exec-once=wl-paste --type text --watch cliphist store
      exec-once=wl-paste --type image --watch cliphist store
      bind=SUPER,V,exec,cliphist list | rofi -dmenu | cliphist decode | wl-copy
    '';
  };
}
