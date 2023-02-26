{ pkgs, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      unstable.freecad
      blender
      gmsh
      calculix
      elmerfem
    ];
  };
}
