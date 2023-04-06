{
  inputs,
  pkgs,
  ...
}: {
  xdg.portal = {
    enable = true;
    extraPortals = [inputs.hyprland.packages.${pkgs.hostPlatform.system}.xdg-desktop-portal-hyprland];
  };
}
