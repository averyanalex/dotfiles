{pkgs, ...}: {
  home-manager.users.alex = {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
    home.packages = with pkgs; [
      gthumb # images
      evince # documents
      f3d # 3d
    ];
  };
}
