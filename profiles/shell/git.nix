{
  home-manager.users.alex.programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "AveryanAlex";
    userEmail = "alex@averyan.ru";

    signing = {
      signByDefault = true;
      key = "3C23C7BD99452036";
    };

    extraConfig = {
      core.editor = "micro";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      tag.gpgsign = true;
    };
  };
}
