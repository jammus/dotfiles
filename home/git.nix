{
  programs.git = {
    enable = true;
    includes = [
      {
        path = "~/work/gitconfig";
        condition = "gitdir:~/work/";
      }
    ];
    settings = {
      user = {
        name = "jammus";
        email = "jammus@gmail.com";
      };
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
  };
  programs.delta = {
    enable = true;
    options = {
      features = "line-numbers decorations gruvbox-dark";
      line-numbers = true;
    };
    enableGitIntegration = true;
  };
}
