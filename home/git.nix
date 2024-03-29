{
  programs.git = {
    enable = true;
    userName = "jammus";
    userEmail = "jammus@gmail.com";
    includes = [
      {
        path = "~/work/gitconfig";
        condition = "gitdir:~/work/";
      }
    ];
    extraConfig = {
      color = {
        branch = "auto";
        diff = "auto";
        status = {
          added = "green";
          changed = "yellow";
          untracked = "red";
        };
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autosquash = true;
      };
      rebase = {
        autoStash = true;
      };
    };
    delta = {
      enable = true;
      options = {
        features = "line-numbers decorations gruvbox-dark";
        line-numbers = true;
      };
    };
  };
}
