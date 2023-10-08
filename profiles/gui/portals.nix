{pkgs, ...}: {
  xdg.portal = {
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdgOpenUsePortal = true;
    config."sway" = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
    };
  };
}
