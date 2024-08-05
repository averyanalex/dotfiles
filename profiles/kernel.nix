{
  pkgs,
  # config,
  # inputs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # inputs.nixpkgs-fork.legacyPackages.x86_64-linux.linuxKernel.packages.linux_zen;
  # boot.extraModulePackages = [config.boot.kernelPackages.amneziawg];
}
