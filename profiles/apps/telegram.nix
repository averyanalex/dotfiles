{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.unstable.telegram-desktop];
  };

  persist.state.homeDirs = [".local/share/TelegramDesktop"];
}
