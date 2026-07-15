{ pkgs, lib, config, inputs, ... }:
let
  # emacs-pgtk is GTK/Wayland (Linux); macOS needs the native macport build.
  emacsPackage = if pkgs.stdenv.isDarwin then pkgs.emacs-macport else pkgs.emacs-pgtk;

  # Native/Nix-coupled packages the Doom config expects on the load-path.
  # kitty-graphics.el is not in MELPA/nixpkgs, so build it from source.
  kitty-graphics = epkgs: epkgs.trivialBuild {
    pname = "kitty-graphics";
    version = "0-unstable-2025-05-04";
    src = pkgs.fetchFromGitHub {
      owner = "cashmeredev";
      repo = "kitty-graphics.el";
      rev = "586ff4b36f2ae44b12d35b0d4f256da23bc71f08";
      hash = "sha256-YqZ82zg303Ss2qlDTMM3xy8lG0BO8+/vdXMO6FxVX5E=";
    };
  };
in
{
  imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  programs.emacs = {
    enable = false;
    # Packages referenced by `:ensure t' in init.el are built by Nix and put on
    # the load-path; nothing is installed over the network at runtime.
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = false;
      package = emacsPackage;
      alwaysEnsure = false;
      extraEmacsPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
        (kitty-graphics epkgs)
      ];
    };
  };

  # Doom Emacs alongside the vanilla build above, for side-by-side comparison.
  # provideEmacs = false keeps this off the `emacs'/`emacsclient' names (those
  # stay bound to programs.emacs); this one installs a `doom-emacs' binary.
  programs.doom-emacs = {
    enable = true;
    provideEmacs = true;
    doomDir = ./emacs/doom.d;
    emacs = emacsPackage;
    # Packages Doom can't fetch from MELPA because Nix has to build native code.
    extraPackages = epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      epkgs.ghostel                 # libghostty terminal, native Zig module
      (kitty-graphics epkgs)
    ];
  };

  # parinfer-rust-mode loads its Rust core from an absolute path rather than
  # downloading it. A GUI-launched Emacs doesn't inherit home.sessionVariables
  # (those only reach login shells), so bake the store path into a file the Doom
  # config loads directly -- mirrors the vanilla emacs nix-paths.el.
  xdg.configFile."doom-nix-paths.el".text = ''
    (setq parinfer-rust-library
          "${pkgs.parinfer-rust-emacs}/lib/libparinfer_rust${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}")
  '';

  # External tools the config expects on PATH.
  home.packages = [
    pkgs.claude-agent-acp

    # org flyspell needs a speller
    (pkgs.aspellWithDicts (ds: with ds; [ en en-computers en-science ]))

    # ob-d2 shells out to the d2 CLI to render diagram blocks
    pkgs.d2

    # dirvish previews/thumbnails shell out to these CLIs.
    pkgs.vips                # vipsthumbnail — image thumbnails
    pkgs.ffmpegthumbnailer   # video thumbnails
    pkgs.mediainfo           # audio/video metadata
    pkgs.poppler-utils       # pdftoppm — PDF previews
    pkgs.imagemagick         # image conversions

    # Language servers always available (outside any project devenv). Everything
    # else is expected to come from a project's devenv via envrc.
    pkgs.nixd                  # Nix LSP (evaluation-powered)
    pkgs.nixfmt                # Nix formatter, driven by nixd
    pkgs.bash-language-server  # Bash
    pkgs.lua-language-server   # Lua
    pkgs.clojure-lsp           # Clojure / ClojureScript / babashka
    pkgs.fennel-ls             # Fennel
  ];

  # macOS only registers GUI apps with LaunchServices when they live under
  # ~/Applications (or /Applications). The macport build ships an Emacs.app, but
  # it sits unreferenced in the Nix store, so `open -a Emacs`, Spotlight, and the
  # Dock can't find it — and launching the bare binary from a shell never gets
  # foreground focus. Alias the bundle in on every activation (a Finder alias,
  # not a symlink, since LaunchServices ignores symlinked .app bundles).
  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    linkEmacsApp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/Applications"
      run rm -rf "$HOME/Applications/Emacs.app"
      run ${pkgs.mkalias}/bin/mkalias \
        ${config.programs.emacs.finalPackage}/Applications/Emacs.app \
        "$HOME/Applications/Emacs.app"
    '';
  };

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
