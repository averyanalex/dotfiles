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
          extraPackages = ps: [ps.pandas ps.numpy ps.scipy ps.matplotlib ps.seaborn ps.opencv4 ps.tqdm ps.ipywidgets ps.widgetsnbextension];
        };

        kernel.rust.main = {
          enable = true;
          runtimePackages = with pkgs; [pkg-config fontconfig freetype expat];
        };
      }
    ];
  });
in {
  home-manager.users.alex.home.packages = [jupyterlab];

  persist.cache.homeDirs = [".jupyter"];
}
