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
          alacritty
          firefox
          mpv
          vscode
          misc
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
          sway
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
          nixld
          pipewire
          podman
          printing
          sdr
          sync
          tank
        ]);
}
