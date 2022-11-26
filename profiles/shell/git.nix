{
  home-manager.users.alex.programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "AveryanAlex";
    userEmail = "alex@averyan.ru";

    signing = {
      signByDefault = true;
      key = "6AF4D168E4B6C49A";
    };

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "micro";
      tag.gpgsign = true;
      pull.rebase = true;
    };
  };
}
