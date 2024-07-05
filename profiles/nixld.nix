{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # imports = [
  #   inputs.nix-ld.nixosModules.nix-ld
  # ];
  programs.nix-ld.enable = true;
}
