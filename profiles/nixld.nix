{pkgs, ...}: {
  programs.nix-ld.enable = true;
  environment.variables = {
    NIX_LD = "${pkgs.glibc}/lib/ld-linux-x86-64.so.2";
  };
}
