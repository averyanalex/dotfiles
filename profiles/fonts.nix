{ lib, pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [ corefonts ];
    # enableDefaultFonts = true;
  };
}
