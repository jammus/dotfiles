;;; config.el -*- lexical-binding: t; -*-

;; Personal configuration ported from the Bedrock init.el. Anything an enabled
;; Doom module already handles (the vertico/corfu stack, evil-collection, magit,
;; dirvish, envrc, org-roam autosync) is deliberately not repeated here.

;; Set before anything else: org lazy-loads, and several org/notes commands read
;; `org-directory' the moment they run. Setting it first also means a later
;; load-time error in this file can't leave it at Doom's ~/org default.
(setq org-directory "~/nb/org/")

;; Store paths injected by Nix (see home/emacs.nix). Currently just sets
;; `parinfer-rust-library'. Loaded from ~/.config rather than this read-only
;; store DOOMDIR, and env-independent so a GUI Emacs picks it up.
(load (expand-file-name "doom-nix-paths.el"
                        (or (getenv "XDG_CONFIG_HOME") "~/.config"))
      t t)

;;; Fonts & theme -----------------------------------------------------------

;; Bedrock set :height 150 (i.e. 15pt) in Hack Nerd Font. font-spec :size is
;; pixels when integer, points when float -- so 15.0 (not 15) matches :height 150.
(setq doom-font (font-spec :family "Hack Nerd Font" :size 15.0))

;; The gruvbox-material variant isn't in doom-themes; it's the local theme file
;; bundled under this DOOMDIR. Doom loads `doom-theme' for us after config runs.
(add-to-list 'custom-theme-load-path (expand-file-name "themes" doom-user-dir))
(setq doom-gruvbox-material-background "medium")
(setq doom-theme 'doom-gruvbox-material)

;; Vim-style relative numbers in programming buffers.
(setq display-line-numbers-type 'relative)

;;; Lisp editing (parinfer) -------------------------------------------------

;; The Rust core is built by Nix; parinfer-rust-library is set by the
;; doom-nix-paths.el loaded above, so we never auto-download it.
(use-package! parinfer-rust-mode
  :init
  (setq parinfer-rust-auto-download nil
        parinfer-rust-dim-parens nil
        parinfer-rust-preferred-mode "smart"
        parinfer-rust-disable-troublesome-modes t)
  :hook ((emacs-lisp-mode lisp-mode lisp-data-mode
          clojure-mode fennel-mode janet-mode) . parinfer-rust-mode))

(after! cider
  (setq cider-repl-display-help-banner nil)
  (require 'cider-eval-sexp-fu))

;;; Terminals with inline graphics -----------------------------------------

;; ghostel (libghostty terminal) and kitty-graphics are built by Nix and put on
;; the load-path via extraPackages, so they're `require'-able without a package!.
(use-package! ghostel
  :commands ghostel)

(use-package! evil-ghostel
  :after (ghostel evil)
  :hook (ghostel-mode . evil-ghostel-mode))

(use-package! kitty-graphics
  :unless (display-graphic-p)
  :config (kitty-graphics-setup))

(setq org-roam-directory (file-name-as-directory
                          (expand-file-name "roam" org-directory))
      org-roam-database-connector 'sqlite-builtin)

(use-package! agent-shell
  :commands agent-shell)

(defun my/cider-eval-enclosing-sexp ()
  "Evaluate the innermost list surrounding point."
  (interactive)
  (save-excursion
    (unless (looking-at-p "\\s(")
      (backward-up-list))
    (evil-jump-item)
    (cider-eval-last-sexp)))

(map! :after cider
      :localleader
      :map clojure-mode-map
      "e e" #'my/cider-eval-enclosing-sexp)
