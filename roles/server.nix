{ inputs, ... }: {
  imports = [
    ./base.nix
  ] ++ (with inputs.self.nixosModules.modules; [
  ]) ++ (with inputs.self.nixosModules.profiles; [
  ]);
}
