{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.unstable.webcord-vencord];
  };

  persist.state.homeDirs = [".config/WebCord"];
}
