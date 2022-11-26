{
  home-manager.users.alex = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh.shellAliases.cd = "z";
  };

  persist.state.homeDirs = [ ".local/share/zoxide" ];
}
