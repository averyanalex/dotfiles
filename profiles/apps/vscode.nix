{
  inputs,
  pkgs,
  lib,
  ...
}: {
  age.secrets.account-wakatime = {
    file = ../../secrets/accounts/wakatime.age;
    owner = "alex";
    group = "users";
    path = "/home/alex/.wakatime.cfg";
  };

  hm = {
    home.packages = with pkgs; [gh-copilot];

    home.file.".vscode/argv.json".text = builtins.toJSON {
      enable-crash-reporter = false;
      password-store = "gnome";
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;

      mutableExtensionsDir = false;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.hostPlatform.system}; [
        # Python
        vscode-marketplace.ms-python.black-formatter
        vscode-marketplace.ms-python.isort
        vscode-marketplace.ms-python.mypy-type-checker
        vscode-marketplace.ms-python.python
        vscode-marketplace.ms-python.vscode-pylance
        vscode-marketplace.njpwerner.autodocstring
        pkgs.vscode-extensions.ms-toolsai.jupyter
        pkgs.vscode-extensions.ms-toolsai.jupyter-renderers
        vscode-marketplace.ms-toolsai.datawrangler

        # Other langs
        open-vsx.james-yu.latex-workshop
        pkgs.vscode-extensions.jnoortheen.nix-ide
        open-vsx.redhat.java
        open-vsx.redhat.vscode-xml
        open-vsx.redhat.vscode-yaml
        open-vsx.tamasfe.even-better-toml
        vscode-marketplace.davidanson.vscode-markdownlint
        vscode-marketplace.galarius.vscode-opencl
        vscode-marketplace.github.vscode-github-actions
        vscode-marketplace.mechatroner.rainbow-csv
        vscode-marketplace.ms-vscode.cpptools
        vscode-marketplace.rust-lang.rust-analyzer
        vscode-marketplace.yzhang.markdown-all-in-one
        # vscode-marketplace.ms-azuretools.vscode-docker

        # SQL
        open-vsx.mtxr.sqltools
        open-vsx.mtxr.sqltools-driver-mysql
        open-vsx.mtxr.sqltools-driver-pg
        open-vsx.mtxr.sqltools-driver-sqlite
        vscode-marketplace.loyieking.smalise
        vscode-marketplace.surendrajat.apklab

        # Tools
        vscode-marketplace.editorconfig.editorconfig
        vscode-marketplace.bierner.emojisense
        vscode-marketplace.earshinov.sort-lines-by-selection
        vscode-marketplace.fill-labs.dependi
        vscode-marketplace.github.copilot
        pkgs.vscode-extensions.github.copilot-chat
        vscode-marketplace.github.vscode-pull-request-github
        vscode-marketplace.gruntfuggly.todo-tree
        vscode-marketplace.stkb.rewrap
        vscode-marketplace.tyriar.sort-lines

        # Misc
        open-vsx.gitlab.gitlab-workflow
        open-vsx.mkhl.direnv
        open-vsx.wakatime.vscode-wakatime
        vscode-marketplace.donjayamanne.githistory
        # vscode-marketplace.eamodio.gitlens
      ];
      userSettings = let
        python = pkgs.python3.withPackages (ps: [
          ps.jupyter
          ps.ipython

          ps.ipympl
          ps.matplotlib
          ps.seaborn

          ps.numpy
          ps.pandas
          ps.tqdm
        ]);
      in {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.serverSettings" = {
          nixd = {
            formatting = {
              command = ["${pkgs.alejandra}/bin/alejandra"];
            };
            options = {
              nixos = {
                expr = "(builtins.getFlake \"/home/alex/projects/averyanalex/nixcfg\").nixosConfigurations.alligator.options";
              };
            };
          };
        };

        "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        "rust-analyzer.check.command" = "clippy";
        # "platformio-ide.useBuiltinPIOCore" = false;

        "[svelte]"."editor.defaultFormatter" = "svelte.svelte-vscode";
        "svelte.enable-ts-plugin" = true;

        "editor.quickSuggestions" = {
          "strings" = true;
        };
        "editor.tabCompletion" = "on";

        "editor.formatOnSave" = true;

        # VCS
        "diffEditor.ignoreTrimWhitespace" = false;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        "editor.fontLigatures" = "'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga'";
        "editor.fontFamily" = "'Monaspace Neon', monospace";
        "terminal.integrated.fontFamily" = "MesloLGS NF";

        # Other
        "editor.unicodeHighlight.allowedLocales".ru = true;
        "files.autoSave" = "afterDelay";
        "redhat.telemetry.enabled" = false;
        "sortLines.filterBlankLines" = true;
        "workbench.startupEditor" = "none";
        "direnv.restart.automatic" = true;

        "C_Cpp.clang_format_path" = "${pkgs.clang-tools}/bin/clang-format";
        "OpenCL.formatting.name" = "${pkgs.clang-tools}/bin/clang-format";

        "python.defaultInterpreterPath" = "${python}/bin/python";
        "python.linting.flake8Enabled" = false;
        "python.linting.flake8Path" = "${pkgs.python3Packages.flake8}/bin/flake8";
        "python.linting.mypyEnabled" = true;
        "python.linting.mypyPath" = "${pkgs.mypy}/bin/mypy";
        "python.linting.pydocstyleEnabled" = true;
        "python.linting.pydocstylePath" = "${pkgs.python3Packages.pydocstyle}/bin/pydocstyle";
        "python.formatting.blackArgs" = ["-l120" "-tpy311"];
        "python.languageServer" = "Pylance";
        "python.sortImports.path" = "${pkgs.python3Packages.isort}/bin/isort";
        "python.formatting.provider" = "black";
        "python.formatting.blackPath" = "${pkgs.black}/bin/black";
        "python.formatting.autopep8Path" = "${pkgs.python3Packages.autopep8}/bin/autopep8";
        "python.formatting.yapfPath" = "${pkgs.yapf}/bin/yapf";
        "python.testing.pytestEnabled" = true;
        "python.testing.pytestPath" = "${pkgs.python3Packages.pytest}/bin/pytest";
        "python.venvPath" = "~/.cache/pypoetry/virtualenvs";
        "python.poetryPath" = "${pkgs.poetry}/bin/poetry";
        "python.analysis.autoImportCompletions" = true;
        # "python.envFile" = "\${workspaceFolder}/.env";
        # "python.analysis.typeCheckingMode" = "basic";
      };
    };
  };

  persist.state.homeDirs = [".config/Code"];
}
