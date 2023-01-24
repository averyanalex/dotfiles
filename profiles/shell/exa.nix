{
  home-manager.users.alex = {
    programs.exa = {
      enable = true;
    };

    programs.zsh.shellAliases = {
      ls = "exa --icons -l";
      la = "exa --icons -la";
      lt = "exa --icons --tree";
      upd = "sudo rm -rf /root/.cache && sudo nixos-rebuild switch --flake github:averyanalex/nixcfg";
      lupd = "sudo nixos-rebuild switch --flake .";
    };
  };
}
