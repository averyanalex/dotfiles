{ lib, pkgs, ... }:
{
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts # Proprietary: Times New Roman, etc
      jetbrains-mono
      meslo-lgs-nf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
    ];
    fontconfig.defaultFonts = {
      monospace = [ "MesloLGS NF" ];
    };
  };
}
