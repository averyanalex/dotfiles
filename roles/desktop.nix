{inputs, ...}: {
  imports =
    [
      ./base.nix
    ]
    ++ (with inputs.self.nixosModules.modules; [
      nebula-frsqr
    ])
    ++ (with inputs.self.nixosModules.profiles;
      with apps;
        [
          d3.freecad
          d3.openscad

          alacritty
          firefox
          kdenlive
          mpv
          notes
          obs
          octave
          office
          open
          openboard
          telegram
          tex
          vscode
        ]
        ++ (with games; [
          minecraft
          xonotic
        ])
        ++ (with gui; [
          # nix-colors
          # stylix
          # sway
          clipboard
          eww
          hyprland
          portals
          rofi
          swaylock
          swaync
          swayosd
          swww
          waybar
          wm
        ])
        ++ [
          adb
          autologin
          embedded
          filemanager
          flatpak
          fonts
          kernel
          light
          mail
          music
          nebula-frsqr
          ntfs
          pipewire
          podman
          printing
          sdr
          sync
          tank
        ]);
}
