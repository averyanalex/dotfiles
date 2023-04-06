{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = [pkgs.unstable.prismlauncher];
  };

  services.syncthing.folders."PrismLauncher" = {
    id = "prismlauncher";
    path = "/home/alex/.local/share/PrismLauncher";
    ignorePerms = false;
    devices = ["hamster" "alligator"];
  };

  persist.state.homeDirs = [".local/share/PrismLauncher"];
}
