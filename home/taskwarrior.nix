{
  programs.taskwarrior = {
    enable = true;
    config = {
      taskd = {
        server = "pistachio:53589";
        trust = "ignore hostname";
      };
    };
  };
}
