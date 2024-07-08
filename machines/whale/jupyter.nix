{
  pkgs,
  config,
  ...
}: let
  rustKernel = pkgs.runCommand "jupyter_rust_kernel" {} ''
    mkdir $out
    export HOME=$(pwd)
    ${pkgs.evcxr}/bin/evcxr_jupyter --install
    mv .local/share/jupyter/kernels/rust/* $out/
  '';
  python = pkgs.python3.withPackages (ps:
    with ps; [
      jupyter
      jupyter-collaboration
      ipython

      ipympl
      matplotlib
      seaborn

      numba
      numpy
      pandas
      pillow
      polars
      scipy
      sympy
      tqdm

      aiohttp
      requests
    ]);
in {
  age.secrets.jupyterlab.file = ../../secrets/creds/jupyter.age;

  systemd.services.jupyterlab = {
    after = ["network.target"];
    description = "Jupyter Lab";
    wantedBy = ["multi-user.target"];
    path = [
      pkgs.rustc
      pkgs.cargo
      pkgs.clang
      pkgs.rust-analyzer
      python
    ];
    script = ''
      mkdir -p ~/.local/share/jupyter/kernels
      rm -f ~/.local/share/jupyter/kernels/rust
      ln -sf ${rustKernel} ~/.local/share/jupyter/kernels/rust
      jupyter lab \
        --no-browser \
        --ip=127.0.0.1 \
        --port 8874 \
        --port-retries 0 \
        --collaborative \
        --autoreload \
        --ServerApp.allow_remote_access=True \
        --ServerApp.use_redirect_file=False
    '';
    serviceConfig = {
      EnvironmentFile = config.age.secrets.jupyterlab.path;
      User = "jupyter";
      Group = "jupyter";
      MemoryMax = "16G";
      Restart = "always";
      WorkingDirectory = "~";
    };
  };

  users.extraUsers.jupyter = {
    uid = 2112;
    group = "jupyter";
    home = "/var/lib/jupyter";
    isSystemUser = true;
    useDefaultShell = true;
  };

  users.groups.jupyter.gid = 2112;

  persist.state.dirs = [
    {
      directory = "/var/lib/jupyter";
      user = "jupyter";
      group = "jupyter";
      mode = "u=rwx,g=,o=";
    }
  ];
}
