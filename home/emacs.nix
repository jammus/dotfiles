{ pkgs, lib, config, inputs, ... }:
let
  # emacs-pgtk is GTK/Wayland (Linux); macOS needs the native macport build.
  emacsPackage = if pkgs.stdenv.isDarwin then pkgs.emacs-macport else pkgs.emacs-pgtk;
in
{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  programs.emacs = {
    enable = true;
    # Packages referenced by `:ensure t' in init.el are built by Nix and put on
    # the load-path; nothing is installed over the network at runtime.
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = false;
      package = emacsPackage;
      alwaysEnsure = false;
      extraEmacsPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
      ];
    };
  };

  # External tools the config expects on PATH.
  home.packages = [
    pkgs.claude-agent-acp

    # org flyspell needs a speller
    (pkgs.aspellWithDicts (ds: with ds; [ en en-computers en-science ]))

    # ob-d2 shells out to the d2 CLI to render diagram blocks
    pkgs.d2

    # Language servers always available (outside any project devenv). Everything
    # else is expected to come from a project's devenv via envrc.
    pkgs.nixd                  # Nix LSP (evaluation-powered)
    pkgs.nixfmt                # Nix formatter, driven by nixd
    pkgs.bash-language-server  # Bash
    pkgs.lua-language-server   # Lua
    pkgs.clojure-lsp           # Clojure / ClojureScript / babashka
    pkgs.fennel-ls             # Fennel
  ];

  xdg.configFile = {
    "emacs/early-init.el".source = ./emacs/early-init.el;
    "emacs/init.el".source = ./emacs/init.el;
    "emacs/themes/doom-gruvbox-material-theme.el".source =
      ./emacs/themes/doom-gruvbox-material-theme.el;

    # Nix store paths consumed by init.el (avoids hardcoding them).
    "emacs/nix-paths.el".text = ''
      (setq parinfer-rust-library "${pkgs.parinfer-rust-emacs}/lib/libparinfer_rust${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}")
    '';
  };
}
