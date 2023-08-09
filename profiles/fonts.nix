{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts # Proprietary: Times New Roman, etc
      jetbrains-mono
      meslo-lgs-nf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
    ];
    fontconfig.defaultFonts = {
      monospace = ["MesloLGS NF"];
    };
  };
}
