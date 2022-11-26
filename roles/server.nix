{ inputs, ... }: {
  imports = [
    ./base.nix
  ] ++ (with inputs.self.nixosModules.modules; [
    nebula-frsqr
  ]) ++ (with inputs.self.nixosModules.profiles; [
    nebula-frsqr
  ]);
}
