{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.openboard pkgs.rnote];
  };

  persist.state.homeDirs = [".local/share/OpenBoard"];
}
