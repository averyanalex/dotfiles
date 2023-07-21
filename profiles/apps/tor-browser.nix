{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.unstable.tor-browser-bundle-bin];
  };

  persist.state.homeDirs = [".local/share/tor-browser"];
}
