{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./vscode.nix
    ./nbconvert.nix
  ];

  nixpkgs.overlays = [inputs.fenix.overlays.default];

  hm.home.packages = [
    (pkgs.python3.withPackages
      (ps:
        with ps; [
          ipympl
          ipython
          jupyter
          matplotlib
          mypy
          numpy
          pandas
          scipy
          seaborn
          tqdm
          numba
          sympy
          olefile
        ]))
    # pkgs.fenix.complete
    pkgs.clang
    (pkgs.fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    pkgs.gdb
  ];
}
