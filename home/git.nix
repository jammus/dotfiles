{
  programs.git = {
    enable = true;
    userName = "jammus";
    userEmail = "jammus@gmail.com";
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
      pull = {
        rebase = true;
      };
      rebase = {
        autosquash = true;
      };
    };
  };
}
