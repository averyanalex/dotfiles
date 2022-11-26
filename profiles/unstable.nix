{ inputs, ... }:

let
  overlay-unstable = final: prev: {
    unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
  };
in
{
  nixpkgs.overlays = [ overlay-unstable ];
}
