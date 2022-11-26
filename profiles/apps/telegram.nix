{ pkgs, ... }:

{
  home-manager.users.alex = {
    home.packages = [ pkgs.unstable.tdesktop ];
  };

  persist.state.homeDirs = [ ".local/share/TelegramDesktop" ];
}
