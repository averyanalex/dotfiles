{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs.jupyenv.lib.${pkgs.hostPlatform.system}) mkJupyterlabNew;
  jupyterlab = mkJupyterlabNew ({...}: {
    nixpkgs = inputs.nixpkgs;
    imports = [
      {
        kernel.python.main = {
          enable = true;
          extraPackages = ps: [ps.numpy ps.scipy ps.matplotlib ps.opencv4];
        };

        kernel.rust.main = {
          enable = true;
        };
      }
    ];
  });
in {
  home-manager.users.alex.home.packages = [jupyterlab];

  persist.cache.homeDirs = [".jupyter"];
}
