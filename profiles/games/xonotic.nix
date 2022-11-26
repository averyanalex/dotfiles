{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.unstable.xonotic ];
  };

  persist.state.homeDirs = [ ".xonotic" ];
}
