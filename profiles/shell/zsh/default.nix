{ config, pkgs, lib, ... }:

{
  home-manager.users.alex = {
    # Autostart zsh in interactive non-tty sessions
    programs.bash.enable = true;
    programs.bash.initExtra = ''
      if [[ "$(tty)" != /dev/tty* && $(ps --no-header --pid=$PPID --format=comm) != "zsh" && -z $BASH_EXECUTION_STRING ]]; then
        exec zsh
      fi
    '';

    # Beautiful cat
    programs.bat.enable = true;

    programs.zsh = {
      enable = true;

      history = {
        size = 30000;
        save = 30000;
        extended = true;
        path = "/home/alex/.local/state/zsh/history";
      };

      dotDir = ".config/zsh";

      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      autocd = true;

      shellAliases = {
        ip = "ip --color=auto";

        # nixupd = ''sudo rm -rf /root/.cache && sudo nixos-rebuild switch --flake "github:averyanalex/nixos"'';
        tnixupd = "sudo nixos-rebuild switch --flake .";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "zsh-interactive-cd"
          "git-auto-fetch"
          "git"
        ];
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];
    };
  };

  environment.pathsToLink = [ "/share/zsh" ];
  persist.state.homeDirs = [ ".local/state/zsh" ];
}
