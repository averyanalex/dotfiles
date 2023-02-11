{ config, pkgs, lib, ... }:

{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      rnix-lsp
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        # JavaScript
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        svelte.svelte-vscode

        # Python
        ms-python.python
        ms-toolsai.jupyter
        njpwerner.autodocstring

        # Rust
        serayuzgur.crates

        # Tools
        editorconfig.editorconfig
        gruntfuggly.todo-tree
        stkb.rewrap
        tyriar.sort-lines

        # Other langs
        james-yu.latex-workshop
        jnoortheen.nix-ide
        mkhl.direnv
        ms-vscode.cpptools
        tamasfe.even-better-toml
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "rust-analyzer";
          publisher = "rust-lang";
          version = "0.4.1399";
          sha256 = "2KxgMIFofrXyZmoW6OO4wpvggDBu2lO9sxptioHCytw=";
        }
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "3.0.0";
          sha256 = "+0haTk/xbPoustJVE81tI9X8gcfiamx8nZBm7kGGY6c=";
        }
        {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.11.10112022";
          sha256 = "/ZD3LOf6d5dJJW7eGZgkrf4hj1CXZJNI0u06Bnmyo0Q=";
        }
        {
          name = "sqltools";
          publisher = "mtxr";
          version = "0.27.1";
          sha256 = "5XhPaxwr0yvIX0wSKDiDm+1iG947s84ULaWpxfpRcAU=";
        }
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "svelte.enable-ts-plugin" = true;

        "rust-analyzer.server.path" = "${pkgs.unstable.rust-analyzer}/bin/rust-analyzer";
        # "platformio-ide.useBuiltinPIOCore" = false;

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

        "editor.unicodeHighlight.allowedLocales".ru = true;
      };
    };
  };

  persist.state.homeDirs = [ ".config/VSCodium" ];
}
