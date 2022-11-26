{ pkgs, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      mpv # media
      gthumb # images
      evince # documents
      f3d # 3d
    ];
  };
}
