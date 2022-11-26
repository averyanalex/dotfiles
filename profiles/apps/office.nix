{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      unstable.libreoffice-fresh
    ];
  };
}
