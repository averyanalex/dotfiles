{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      joplin-desktop
    ];
  };

  persist.state.homeDirs = [
    ".config/Joplin"
    ".config/joplin-desktop"
  ];
}
