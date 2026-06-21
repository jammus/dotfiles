;;; init.el --- Bedrock-based config, packages provisioned by Nix -*- lexical-binding: t; -*-

;;; This is Emacs Bedrock (https://codeberg.org/ashton314/emacs-bedrock) with the
;;; recommended `extras/base.el' and `extras/dev.el' inlined, adapted so that all
;;; packages are built and placed on the load-path by Nix rather than installed
;;; by package.el at runtime.

;;; Guardrail
(when (< emacs-major-version 29)
  (error "This config only works with Emacs 29 and newer; you have %s" emacs-version))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Nix integration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The `:ensure t' annotations below are read by the Nix parser
;; (emacsWithPackagesFromUsePackage) to decide which packages to build. At
;; runtime those packages are already on the load-path, so `:ensure' must be a
;; no-op -- we never want use-package to reach out to ELPA.
(require 'use-package)
(setq use-package-always-ensure nil
      use-package-ensure-function 'ignore)

;; Store paths injected by Nix (see home/emacs.nix).
(load (expand-file-name "nix-paths.el" user-emacs-directory) t t)

;; Keep the Customize machinery out of this read-only, Nix-managed file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Basic settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If you want to turn off the welcome screen, uncomment this
;(setopt inhibit-splash-screen t)

(setopt initial-major-mode 'fundamental-mode)  ; default mode for the *scratch* buffer
(setopt display-time-default-load-average nil) ; this information is useless for most

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of minibuffer
(savehist-mode)

;; Move through windows with Ctrl-<arrow keys>
(windmove-default-keybindings 'control) ; You can use other modifiers here

;; Fix archaic defaults
(setopt sentence-end-double-space nil)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.config/emacs/emacs-backup or wherever
(defun bedrock--backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir (concat user-emacs-directory "emacs-backup/"))
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'bedrock--backup-file-name)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Discovery aids
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; which-key: shows a popup of available keybindings when typing a long key
;; sequence (e.g. C-x ...)
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Minibuffer/completion settings
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; For help, see: https://www.masteringemacs.org/article/understanding-minibuffer-completion

(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)            ; Much more eager

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Interface enhancements/defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent

(setopt show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

;; Misc. UI tweaks
(blink-cursor-mode -1)                                ; Steady cursor
(pixel-scroll-precision-mode)                         ; Smooth scrolling

;; Use common keystrokes by default
(cua-mode)

;; For terminal users, make the mouse more useful
(xterm-mouse-mode 1)

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Tab-bar configuration
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Show the tab-bar as soon as tab-bar functions are invoked
(setopt tab-bar-show 1)

;; Add the time to the tab-bar, if visible
(add-to-list 'tab-bar-format 'tab-bar-format-align-right 'append)
(add-to-list 'tab-bar-format 'tab-bar-format-global 'append)
(setopt display-time-format "%a %F %T")
(setopt display-time-interval 1)
(display-time-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package doom-themes
  :ensure t
  :config
  (add-to-list 'custom-theme-load-path
               (expand-file-name "themes" user-emacs-directory))
  (custom-set-variables '(doom-gruvbox-material-background "medium"))
  (load-theme 'doom-gruvbox-material t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Base enhancements (extras/base.el)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Motion aids

(use-package avy
  :ensure t
  :demand t
  :bind (("C-c j" . avy-goto-line)
         ("s-j"   . avy-goto-char-timer)))

;;; Power-ups: Embark and Consult

;; Consult: Misc. enhanced commands
(use-package consult
  :ensure t
  :bind (
         ;; Drop-in replacements
         ("C-x b" . consult-buffer)     ; orig. switch-to-buffer
         ("M-y"   . consult-yank-pop)   ; orig. yank-pop
         ;; Searching
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)       ; Alternative: rebind C-s to use
         ("M-s s" . consult-line)       ; consult-line instead of isearch, bind
         ("M-s L" . consult-line-multi) ; isearch to M-s s
         ("M-s o" . consult-outline)
         ;; Isearch integration
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)   ; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history) ; orig. isearch-edit-string
         ("M-s l" . consult-line)            ; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)      ; needed by consult-line to detect isearch
         )
  :config
  ;; Narrowing lets you restrict results to certain groups of candidates
  (setq consult-narrow-key "<"))

(use-package embark-consult
  :ensure t)

;; Embark: supercharged context-dependent menu; kinda like a
;; super-charged right-click.
(use-package embark
  :ensure t
  :demand t
  :after (avy embark-consult)
  :bind (("C-c a" . embark-act))        ; bind this to an easy key to hit
  :init
  ;; Add the option to run embark when using avy
  (defun bedrock/avy-action-embark (pt)
    (unwind-protect
        (save-excursion
          (goto-char pt)
          (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)

  ;; After invoking avy-goto-char-timer, hit "." to run embark at the next
  ;; candidate you select
  (setf (alist-get ?. avy-dispatch-alist) 'bedrock/avy-action-embark))

;;; Minibuffer and completion

;; Vertico: better vertical completion for minibuffer commands
(use-package vertico
  :ensure t
  :init
  ;; You'll want to make sure that e.g. fido-mode isn't enabled
  (vertico-mode))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("M-DEL" . vertico-directory-delete-word)))

;; Marginalia: annotations for minibuffer
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

;; Corfu: Popup completion-at-point
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :bind
  (:map corfu-map
        ("SPC" . corfu-insert-separator)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)))

;; Part of corfu
(use-package corfu-popupinfo
  :after corfu
  :ensure nil
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.25 . 0.1))
  (corfu-popupinfo-hide nil)
  :config
  (corfu-popupinfo-mode))

;; Make corfu popup come up in terminal overlay
(use-package corfu-terminal
  :if (not (display-graphic-p))
  :ensure t
  :config
  (corfu-terminal-mode))

;; Fancy completion-at-point functions; there's too much in the cape package to
;; configure here; dive in when you're comfortable!
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;; Pretty icons for corfu
(use-package kind-icon
  :if (display-graphic-p)
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package eshell
  :init
  (defun bedrock/setup-eshell ()
    ;; Something funny is going on with how Eshell sets up its keymaps; this is
    ;; a work-around to make C-r bound in the keymap
    (keymap-set eshell-mode-map "C-r" 'consult-history))
  :hook ((eshell-mode . bedrock/setup-eshell)))

;; Eat: Emulate A Terminal
(use-package eat
  :ensure t
  :custom
  (eat-term-name "xterm")
  :config
  (eat-eshell-mode)                     ; use Eat to handle term codes in program output
  (eat-eshell-visual-command-mode))     ; commands like less will be handled by Eat

;; Orderless: powerful completion style
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless)))

;;; Misc. editing enhancements

;; Modify search results en masse
(use-package wgrep
  :ensure t
  :config
  (setq wgrep-auto-save-buffer t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Development tools (extras/dev.el)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Built-in config for developers

(use-package emacs
  :config
  ;; Prefer the tree-sitter modes; grammars are provided by Nix
  ;; (treesit-grammars.with-all-grammars in home/emacs.nix).
  (setq major-mode-remap-alist
        '((yaml-mode   . yaml-ts-mode)
          (sh-mode     . bash-ts-mode)
          (js-mode     . js-ts-mode)
          (json-mode   . json-ts-mode)
          (css-mode    . css-ts-mode)
          (python-mode . python-ts-mode)))
  ;; Languages with no built-in base mode to remap from
  (add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)))

(use-package project
  :custom
  (when (>= emacs-major-version 30)
    (project-mode-line t)))         ; show project name in modeline

;;; Version Control

;; Magit: best Git client to ever exist
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;; Common file types

(use-package markdown-mode
  :ensure t
  :hook ((markdown-mode . visual-line-mode)))

(use-package yaml-mode
  :ensure t)

(use-package json-mode
  :ensure t)

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;;; Eglot, the built-in LSP client for Emacs

;; envrc: give each buffer the direnv environment of its directory, so eglot
;; launches language servers from a project's devenv rather than needing them
;; installed globally. Buffer-local, so multiple projects coexist correctly.
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package eglot
  ;; no :ensure t here because it's built-in

  ;; Auto-start eglot for these modes. Safe even when the server isn't on PATH:
  ;; eglot just reports it couldn't start and leaves the buffer alone. Servers
  ;; come either from the global set (home/emacs.nix) or a project's devenv.
  :hook ((nix-mode           . eglot-ensure)
         (bash-ts-mode       . eglot-ensure)
         (python-ts-mode     . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode        . eglot-ensure)
         (js-ts-mode         . eglot-ensure)
         (lua-ts-mode        . eglot-ensure)
         (clojure-mode       . eglot-ensure)
         (clojurescript-mode . eglot-ensure)
         (clojurec-mode      . eglot-ensure)
         (fennel-mode        . eglot-ensure)
         (janet-mode         . eglot-ensure))

  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files

  :config
  (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event

  ;; Use nixd for Nix (eglot would otherwise default to nil).
  (add-to-list 'eglot-server-programs '((nix-mode nix-ts-mode) . ("nixd")))
  ;; Servers eglot doesn't know out of the box.
  (add-to-list 'eglot-server-programs '(fennel-mode . ("fennel-ls")))
  (add-to-list 'eglot-server-programs '(janet-mode . ("janet-lsp")))

  ;; Point nixd at this flake so it can complete nixpkgs attributes plus NixOS
  ;; and home-manager module options. Derived from ~/dots and the current
  ;; hostname, so it targets this machine's nixosConfigurations entry.
  (let ((flake (expand-file-name "~/dots"))
        (host (car (split-string (system-name) "\\."))))
    (setq-default eglot-workspace-configuration
                  `(:nixd
                    (:nixpkgs
                     (:expr ,(format "import (builtins.getFlake \"%s\").inputs.nixpkgs {}" flake))
                     :formatting (:command ["nixfmt"])
                     :options
                     (:nixos
                      (:expr ,(format "(builtins.getFlake \"%s\").nixosConfigurations.%s.options" flake host))
                      :home-manager
                      (:expr ,(format "(builtins.getFlake \"%s\").nixosConfigurations.%s.options.home-manager.users.type.getSubOptions []" flake host)))))))

  ;; Let orderless drive eglot's completion candidates
  (setq completion-category-overrides
        '((eglot (styles orderless))
          (eglot-capf (styles orderless)))))

;;; Templating

(use-package tempel
  :ensure t
  :bind (("M-*" . tempel-insert)
         ("M-+" . tempel-complete)
         :map tempel-map
         ("C-c RET" . tempel-done)
         ("C-<down>" . tempel-next)
         ("C-<up>" . tempel-previous)
         ("M-<down>" . tempel-next)
         ("M-<up>" . tempel-previous))
  :init
  ;; Make a function that adds the tempel expansion function to the
  ;; list of completion-at-point-functions (capf).
  (defun tempel-setup-capf ()
    (add-hook 'completion-at-point-functions #'tempel-expand -1 'local))
  ;; Put tempel-expand on the list whenever you start programming or
  ;; writing prose.
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Lisp languages & REPLs (Clojure/babashka, Fennel, Janet)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package parinfer-rust-mode
  :ensure t
  :init
  (setq parinfer-rust-auto-download nil)
  (setq parinfer-rust-dim-parens nil)
  (setq parinfer-rust-preferred-mode "smart")
  (setq parinfer-rust-disable-troublesome-modes t)
  :hook ((emacs-lisp-mode . parinfer-rust-mode)
         (lisp-mode       . parinfer-rust-mode)
         (lisp-data-mode  . parinfer-rust-mode)
         (clojure-mode    . parinfer-rust-mode)
         (fennel-mode     . parinfer-rust-mode)
         (janet-mode      . parinfer-rust-mode)))

(use-package clojure-mode
  :ensure t
  :mode ("\\.bb\\'" . clojure-mode))

(use-package cider
  :ensure t
  :config
  (setq cider-repl-display-help-banner nil))

(use-package fennel-mode
  :ensure t
  :mode "\\.fnl\\'")

(use-package janet-mode
  :ensure t
  :mode "\\.janet\\'")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   AI agent shell
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The Anthropic backend spawns `claude-agent-acp', provided via home/emacs.nix.
(use-package agent-shell
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Vim emulation (extras/vim-like.el)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Evil: vi emulation
(use-package evil
  :ensure t
  :init
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-u-scroll t)         ; C-u scrolls up, like pure Vim
  ;; evil-collection wants this set before evil loads
  (setq evil-want-keybinding nil)
  :config
  ;; CUA bindings (enabled by the Bedrock base) fight Vim's C-x/C-c/C-v; turn
  ;; them off now that we're driving with Evil.
  (cua-mode -1)
  (evil-mode)

  ;; If you use Magit, start editing commit messages in insert state
  (add-hook 'git-commit-setup-hook 'evil-insert-state)

  ;; Use Emacs state in terminal emulators
  (evil-set-initial-state 'eat-mode 'emacs)
  (evil-set-initial-state 'vterm-mode 'emacs))

;; evil-collection: consistent Vim bindings across built-in and third-party
;; modes (dired, magit, info, etc.)
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Org-mode (extras/org.el)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Where org looks for agenda/capture files. Adjust to taste -- non-absolute
;; paths in templates below are resolved relative to this directory.
(setq org-directory "~/Documents/org/")
(setq org-agenda-files '("inbox.org" "work.org"))

;; aspell is provided via Nix (see home/emacs.nix); makes flyspell work.
(setq ispell-program-name "aspell")

;; Default tags
(setq org-tag-alist '((:startgroup)
                      ("home" . ?h)
                      ("work" . ?w)
                      ("school" . ?s)
                      (:endgroup)
                      (:newline)
                      (:startgroup)
                      ("one-shot" . ?o)
                      ("project" . ?j)
                      ("tiny" . ?t)
                      (:endgroup)
                      ("meta")
                      ("review")
                      ("reading")))

(use-package org
  ;; org is built-in; no :ensure
  :hook ((org-mode . visual-line-mode)  ; wrap lines at word breaks
         (org-mode . flyspell-mode))    ; spell checking
  :bind (:map global-map
              ("C-c A" . org-agenda)                ; C-c a is embark-act (base.el)
              ("C-c c" . org-capture)
              ("C-c l s" . org-store-link)          ; Mnemonic: link -> store
              ("C-c l i" . org-insert-link-global)) ; Mnemonic: link -> insert
  :config
  (require 'oc-csl)                     ; citation support
  (add-to-list 'org-export-backends 'md)

  ;; Follow file links in the same window
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)
  (setq org-export-with-smart-quotes t)

  ;; Task states
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)" "|" "DONE(d!)" "OBSOLETE(o@)")))

  ;; Refile within agenda files, up to 3 levels deep
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path 'file)
  (setq org-refile-targets '((nil :maxlevel . 3)
                             (org-agenda-files :maxlevel . 3)))

  (setq org-capture-templates
        '(("c" "Default Capture" entry (file "inbox.org")
           "* TODO %?\n%U\n%i")
          ;; Capture and keep an org-link to the thing we're currently working with
          ("r" "Capture with Reference" entry (file "inbox.org")
           "* TODO %?\n%U\n%i\n%a")
          ("w" "Work")
          ("wm" "Work meeting" entry (file+headline "work.org" "Meetings")
           "** TODO %?\n%U\n%i\n%a")
          ("wr" "Work report" entry (file+headline "work.org" "Reports")
           "** TODO %?\n%U\n%i\n%a")))

  (setq org-agenda-custom-commands
        '(("n" "Agenda and All Todos"
           ((agenda)
            (todo)))
          ("w" "Work" agenda ""
           ((org-agenda-files '("work.org")))))))

;; Restore the GC threshold lowered for fast startup (set in early-init.el)
(setq gc-cons-threshold (or bedrock--initial-gc-threshold 800000))

;;; init.el ends here
