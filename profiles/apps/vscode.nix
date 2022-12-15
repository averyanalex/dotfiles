{ config, pkgs, lib, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      rnix-lsp
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscodium;
      mutableExtensionsDir = false;
      extensions = with pkgs.unstable.vscode-extensions; [
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        editorconfig.editorconfig
        esbenp.prettier-vscode
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
        ms-python.python
        ms-toolsai.jupyter
        serayuzgur.crates
        stkb.rewrap
        tyriar.sort-lines
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "106.2.0";
          sha256 = "ULLDfiYU7mAneth22/F4PJ9Q70Dq1gsJglb920WriBI=";
        }
        {
          name = "gitlab-workflow";
          publisher = "GitLab";
          version = "3.57.1";
          sha256 = "zdhhH8ebSq6e+Y9kL+v0Br3lao0ZSEbXxCK9pw2tSFM=";
        }
        {
          name = "even-better-toml";
          publisher = "tamasfe";
          version = "0.19.0";
          sha256 = "MqSQarNThbEf1wHDTf1yA46JMhWJN46b08c7tV6+1nU=";
        }
        {
          name = "rust-analyzer";
          publisher = "rust-lang";
          version = "0.4.1302";
          sha256 = "+lzku5m+k9CK1kILjICq3yoKeqtnL2VwDV9b3H3L0hY=";
        }
        {
          name = "direnv";
          publisher = "mkhl";
          version = "0.10.1";
          sha256 = "Da9Anme6eoKLlkdYaeLFDXx0aQgrtepuUnw2jEPXCVU=";
        }
        {
          name = "autodocstring";
          publisher = "njpwerner";
          version = "0.6.1";
          sha256 = "NI0cbjsZPW8n6qRTRKoqznSDhLZRUguP7Sa/d0feeoc=";
        }
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "svelte.enable-ts-plugin" = true;
        "rust-analyzer.server.path" = "${pkgs.unstable.rust-analyzer}/bin/rust-analyzer";

        "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";

        "editor.quickSuggestions" = {
          "strings" = true;
        };

        "sortLines.filterBlankLines" = true;

        "files.autoSave" = "afterDelay";
        "diffEditor.ignoreTrimWhitespace" = false;

        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        "terminal.integrated.fontFamily" = "MesloLGS NF";
      };
    };
  };

  persist.state.homeDirs = [ ".config/VSCodium" ];
}
