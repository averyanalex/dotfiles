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

      autologin
      flatpak
      kernel
      music
      nebula-frsqr
      pipewire
      sync
      tank
      waydroid
    ]);
}
