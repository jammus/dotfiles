{
  programs.taskwarrior = {
    enable = true;
    config = {
      taskd = {
        server = "100.104.40.62:53589";
        trust = "ignore hostname";
      };
    };
  };
}
