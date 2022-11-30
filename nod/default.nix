{ inputs, config, lib, pkgs, ... }:

{
  environment.packages = with pkgs; [
    micro
  ];

  system.stateVersion = "22.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Moscow";

  # Configure home-manager
  home-manager = {
    config = inputs.self.roles.base.home-manager.users.alex;
    useGlobalPkgs = true;
  };
}
