{
  home-manager.users.alex = {
    programs.eza = {
      enable = true;
    };

    programs.zsh.shellAliases = {
      ls = "eza --icons -l";
      la = "eza --icons -la";
      lt = "eza --icons --tree";
    };
  };
}
