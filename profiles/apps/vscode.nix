{
  inputs,
  pkgs,
  ...
}: {
  age.secrets.account-wakatime = {
    file = ../../secrets/accounts/wakatime.age;
    owner = "alex";
    group = "users";
    path = "/home/alex/.wakatime.cfg";
  };

  home-manager.users.alex = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      mutableExtensionsDir = false;
      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}; [
        # Python
        open-vsx.ms-python.python
        open-vsx.ms-toolsai.jupyter
        open-vsx.njpwerner.autodocstring

        # Other langs
        open-vsx.redhat.java
        open-vsx.redhat.vscode-xml
        open-vsx.redhat.vscode-yaml
        open-vsx.tamasfe.even-better-toml
        vscode-marketplace.rust-lang.rust-analyzer
        vscode-marketplace.ms-vscode.cpptools
        open-vsx.james-yu.latex-workshop
        open-vsx.jnoortheen.nix-ide
        open-vsx.galarius.vscode-opencl

        # SQL
        open-vsx.mtxr.sqltools
        open-vsx.mtxr.sqltools-driver-mysql
        open-vsx.mtxr.sqltools-driver-pg
        open-vsx.mtxr.sqltools-driver-sqlite

        # Tools
        open-vsx.editorconfig.editorconfig
        vscode-marketplace.earshinov.sort-lines-by-selection
        vscode-marketplace.gruntfuggly.todo-tree
        vscode-marketplace.stkb.rewrap
        vscode-marketplace.tyriar.sort-lines

        # Misc
        open-vsx.mkhl.direnv
        open-vsx.gitlab.gitlab-workflow
        open-vsx.wakatime.vscode-wakatime
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";

        "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        "rust-analyzer.check.command" = "clippy";
        # "platformio-ide.useBuiltinPIOCore" = false;

        "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
        "svelte.enable-ts-plugin" = true;

        "editor.quickSuggestions" = {
          "strings" = true;
        };

        # VCS
        "diffEditor.ignoreTrimWhitespace" = false;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        "terminal.integrated.fontFamily" = "MesloLGS NF";

        # Other
        "editor.unicodeHighlight.allowedLocales".ru = true;
        "files.autoSave" = "afterDelay";
        "redhat.telemetry.enabled" = false;
        "sortLines.filterBlankLines" = true;
      };
    };
  };

  persist.state.homeDirs = [".config/VSCodium"];
}
