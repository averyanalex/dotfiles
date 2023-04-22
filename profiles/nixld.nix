{inputs, ...}: let
  overlay-nixld = final: prev: {
    nix-ld = inputs.nix-ld.packages.${prev.system}.nix-ld;
  };
in {
  nixpkgs.overlays = [overlay-nixld];
  disabledModules = [
    "programs/nix-ld.nix"
  ];
  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/programs/nix-ld.nix")
    inputs.nix-ld.nixosModules.nix-ld
  ];
}
