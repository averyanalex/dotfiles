{inputs, ...}: let
  overlay-stable = final: prev: {
    stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
  };
in {
  nixpkgs.overlays = [overlay-stable];
}
