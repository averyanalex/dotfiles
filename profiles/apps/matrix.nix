{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.unstable.schildichat-desktop];
  };

  persist.state.homeDirs = [".config/SchildiChat"];
}
