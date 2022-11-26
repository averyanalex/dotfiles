{
  home-manager.users.alex = {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;

      nix-direnv.enable = true;
    };
  };

  persist.state.homeDirs = [ ".local/share/direnv" ];
}
