{ inputs, pkgs, ... }:
let
  # prismlauncher = inputs.prismlauncher.packages.x86_64-linux.prismlauncher.overrideAttrs (final: prev: {
  prismlauncher = pkgs.prismlauncher.overrideAttrs (final: prev: {
    buildInputs = prev.buildInputs ++ [ pkgs.unstable.mangohud ];
  });
in
{
  home-manager.users.alex = {
    home.packages = [ prismlauncher ];
  };

  services.syncthing.folders."PrismLauncher" = {
    id = "prismlauncher";
    path = "/home/alex/.local/share/PrismLauncher";
    ignorePerms = false;
    devices = [ "hamster" "alligator" ];
  };

  persist.state.homeDirs = [ ".local/share/PrismLauncher" ];
}
