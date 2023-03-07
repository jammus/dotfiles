{ lib, ... }:
let fgDark = "#1d2021";
    fgLight = "#d4be98";

    machineBg = "#e78a43";
    machineStyle = "fg:${fgDark} bg:${machineBg}";

    pathBg = "#d8a657";
    pathStyle = "fg:${fgDark} bg:${pathBg}";

    gitBg = "#928374";
    gitStyle = "fg:${fgDark} bg:${gitBg}";

    langBg = "#504945";
    langStyle = "fg:${fgLight} bg:${langBg}";

    statusBg = "#32302f";
    statusStyle = "fg:${fgLight} bg:${statusBg}";
    durationStyle = "bold yellow bg:${statusBg}"; in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      format = lib.concatStrings [
        "[█](${machineBg})"
        "$os"
        "$battery"
        "$username"
        "$hostname"

        "[](bg:${pathBg} fg:${machineBg})"

        "$directory"

        "[ ](bg:${gitBg} fg:${pathBg})"

        "$git_branch"
        "$git_state"
        "$git_status"

        "[ ](bg:${langBg} fg:${gitBg})"

        "$nix_shell"
        "$c"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$env_var"

        "[ ](bg:${statusBg} fg:${langBg})"

        "$cmd_duration"

        "[ ](fg:${statusBg})"

      ];
      package = {
        format = "[$symbol$version]($style)";
      };
      os = {
        disabled = false;
        symbols = {
          Macos = " ";
          NixOS = " ";
        };
        style = machineStyle;
      };
      username = {
        style_user = machineStyle;
        style_root = machineStyle;
        format = "[$user]($style)";
      };
      hostname = {
        style = machineStyle;
        format = "[@$hostname ]($style)";
      };
      directory = {
        style = pathStyle;
        format = "[ $path ]($style)";
      };
      git_status = {
        style = gitStyle;
        format = "[$all_status$ahead_behind ]($style)";
      };
      git_state = {
        style = gitStyle;
        format = "\([$state( $progress_current/$progress_total) ]($style)\)";
      };
      git_branch = {
        symbol = "";
        style = gitStyle;
        format = "[$symbol $branch ]($style)";
      };
      nix_shell = {
        symbol = "";
        style = langStyle;
        format = "[$symbol ]($style)";
      };
      env_var.JAVA_HOME = {
        symbol = "";
        style = langStyle;
        format = "[$symbol ]($style)";
      };
      nodejs = {
        symbol = "";
        not_capable_style = langStyle;
        style = langStyle;
        format = "[$symbol ]($style)";
      };
      python = {
        symbol = "";
        detect_files = [];
        detect_extensions = [];
        style = langStyle;
        format = "[$symbol ]($style)";
      };
      cmd_duration = {
        format = "[took ](${statusStyle})[$duration ](${durationStyle})";
      };
    };
  };
}
