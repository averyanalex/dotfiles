{pkgs, ...}: {
  home-manager.users.alex = {
    home.packages = with pkgs; [
      octaveFull
    ];
  };
}
