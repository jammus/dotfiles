;; -*- no-byte-compile: t; -*-
;;; packages.el

;; Packages the enabled Doom modules don't already pull in. Everything the
;; :completion/:tools/:lang modules provide (vertico, consult, embark, corfu,
;; cape, magit, cider, org-roam, envrc, ...) is intentionally absent here.
;;
;; Under unstraightened these `package!' calls resolve against emacs-overlay's
;; snapshot -- no network fetch at runtime. Native-code packages that Nix has to
;; build (ghostel, kitty-graphics, the parinfer library) are NOT here; they come
;; in through `programs.doom-emacs.extraPackages' in home/emacs.nix instead.

;; --- Lisp editing ---------------------------------------------------------
;; Bedrock used parinfer for all lisps rather than Doom's default smartparens.
(package! parinfer-rust-mode)

;; --- Extra language majors Doom has no module for -------------------------
(package! fennel-mode)                                  ; also provides ob-fennel
(package! janet-mode)
;; Prefer the tree-sitter Nix major over Doom's nix-mode (kept as a fallback by
;; the :lang nix module for the eglot server-program entry).
(package! nix-ts-mode)

;; --- Templating -----------------------------------------------------------
;; Bedrock used Tempel rather than Doom's yasnippet (:editor snippets is off).
(package! tempel)

;; --- Org add-ons ----------------------------------------------------------
(package! org-modern)
(package! ob-d2)                                        ; d2 diagram source blocks

;; --- AI agent shell -------------------------------------------------------
;; All three are on MELPA; these are the lines from agent-shell's own Doom
;; install notes. It spawns the `claude-agent-acp' binary provided by Nix.
(package! shell-maker)
(package! acp)
(package! agent-shell)
