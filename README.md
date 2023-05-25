# Welcome to AveryanAlex's NixOS configuration!

# Machines

## Whale

Home server. 64 GB DDR4 2133 MHz, 4 channels; 1x Intel Xeon E5-2696v3; 500 Gb Samsung 970 EVO Plus, 8 TB WD Red.

## Alligator

Main PC. 32 GB DDR4 3200 MHz, 2 channels; AMD Ryzen 7 5800X; Radeon RX 6800 XT; 500 Gb Samsung 970 EVO Plus, 1 TB WD Blue.

# Nebula

- Hawk 10.5.3.12
- Whale 10.5.3.20
- Lizard 10.5.3.40
- Hamster 10.5.3.100
- Alligator 10.5.3.101

# Commands

```shell
_ rm -rf /root/.cache && _ nixos-rebuild switch --flake github:averyanalex/nixcfg
nix flake update --commit-lock-file

EDITOR=cat agenix -e secrets/nebula/ca-crt.age > ca.crt
EDITOR=cat agenix -e secrets/nebula/ca-key.age > ca.key
nebula-cert sign -name lizard -ip 10.5.3.40/24
nix build .#nixosConfigurations.rpi-image.config.system.build.sdImage --builders ""
```

# What I use:

## Shell

<!-- - [Zsh](https://www.zsh.org/) -->

- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme

## Desktop

- [Hyprland](https://hyprland.org/) - Tiling Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - Wayland bar
- [SWWW](https://github.com/Horus645/swww) - Wayland wallpaper daemon
- [MPV](https://mpv.io/) - Media player
<!-- - Firefox -->
