{
  home-manager.users.alex = {
    programs.exa = {
      enable = true;
    };

    programs.zsh.shellAliases = {
      ls = "exa --icons -l";
      la = "exa --icons -la";
      lt = "exa --icons --tree";
    };
  };
}
