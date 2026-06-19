{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];

  programs.emacs = {
    enable = true;
    # emacs-pgtk: native Wayland on giant-head, runs `-nw` in the terminal on
    # taskmaster. Packages referenced by `:ensure t' in init.el are built by Nix
    # and put on the load-path; nothing is installed over the network at runtime.
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = false;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = false;
    };
  };

  xdg.configFile = {
    "emacs/early-init.el".source = ./emacs/early-init.el;
    "emacs/init.el".source = ./emacs/init.el;
  };
}
