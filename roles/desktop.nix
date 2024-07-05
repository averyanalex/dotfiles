{inputs, ...}: {
  imports =
    [
      ./full.nix
    ]
    ++ (with inputs.self.nixosModules.profiles;
      with apps;
        [
          alacritty
          firefox
          misc-a
          mpv
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
          portals
          rofi
          sway
          swaylock
          swaync
          swayosd
          swww
          waybar
          wm
        ])
        ++ [
          # jupyter
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
          proxy
          sdr
          shell.rust
          sync
          tank
          waydroid
          wireshark
        ]);
}
