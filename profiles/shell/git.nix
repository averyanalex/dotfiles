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
      init.defaultBranch = "main";
      core.editor = "micro";
      tag.gpgsign = true;
      pull.rebase = true;
    };
  };
}
