{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
    syntaxes = {
      fennel = {
        src = pkgs.fetchFromGitHub {
          owner = "gbaptista";
          repo = "sublime-text-fennel";
          rev = "v0.1.2";
          hash = "sha256-puHDk0xDvdOfNGOkuc4AqaE/fSNm5vVFqoaFkL1vXIY=";
        };
        file = "Fennel.sublime-syntax";
      };
    };
  };
}
