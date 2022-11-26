{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.openboard ];
  };

  persist.state.homeDirs = [ ".local/share/OpenBoard" ];
}
