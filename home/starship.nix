{ lib, ... }:
let fgDark = "#1d2021";
    fgLight = "#d4be98";

    hostBg = "#e78a43";
    hostStyle = "fg:${fgDark} bg:${hostBg}";

    pathBg = "#d8a657";
    pathStyle = "fg:${fgDark} bg:${pathBg}";

    gitBg = "#89b482";
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
        "[█](${hostBg})"
        "$os"
        "$battery"
        "$username"

        "[](bg:${pathBg} fg:${hostBg})"

        "$directory"

        "[](bg:${gitBg} fg:${pathBg})"

        "$git_branch"
        "$git_status"

        "[](bg:${langBg} fg:${gitBg})"

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
        "$java"
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

        "[](bg:${statusBg} fg:${langBg})"

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
        };
        style = hostStyle;
      };
      directory = {
        style = pathStyle;
        format = "[ $path ]($style)";
      };
      git_status = {
        style = gitStyle;
        format = "[$all_status$ahead_behind ]($style)";
      };
      git_branch = {
        style = gitStyle;
        format = "[ $symbol $branch ]($style)";
      };
      python = {
        symbol = "";
        style = langStyle;
        format = "[ $symbol ($version) ]($style)";
      };
      cmd_duration = {
        format = "[ took ](${statusStyle})[$duration ](${durationStyle})";
      };
    };
  };
}
