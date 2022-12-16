{ inputs, ... }: {
  imports = [
    ./base.nix
  ] ++ (with inputs.self.nixosModules.modules; [
    nebula-frsqr
    waydroid
  ]) ++ (with inputs.self.nixosModules.profiles;
    with apps; [
      d3.cura
      d3.freecad
      d3.openscad

      firefox
      kdenlive
      obs
      office
      open
      openboard
      telegram
      tex
      vscode
    ] ++ (with games; [
      minecraft
      xonotic
    ]) ++ [
      sway

      adb
      arduino
      autologin
      flatpak
      kernel
      mail
      music
      nebula-frsqr
      pipewire
      podman
      sync
      tank
      waydroid
    ]);
}
