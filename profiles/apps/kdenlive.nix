{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = with pkgs.unstable; [
      libsForQt5.kdenlive
      mediainfo
    ];
  };
}
