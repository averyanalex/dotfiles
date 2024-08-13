{
  inputs,
  pkgs,
  ...
}: {
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
          autologin
          embedded
          filemanager
          flatpak
          fonts
          kernel
          light
          mail
          music
          podman
          printing
          sdr
          shell.rust
          sync
          tank
          waydroid
          opensnitch
        ]);

  networking.proxy = {
    httpProxy = "http://127.0.0.1:8118";
    httpsProxy = "http://127.0.0.1:8118";
  };

  nixcfg.desktop = true;

  hm.services.network-manager-applet.enable = true;
  programs.adb.enable = true;
  programs.wireshark.enable = true;
  environment.systemPackages = [pkgs.wireshark];
  programs.nix-ld.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
