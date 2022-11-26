{ pkgs, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      freecad
      gmsh
      calculix
      elmerfem
    ];
  };
}
