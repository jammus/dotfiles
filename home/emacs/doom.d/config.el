;;; config.el -*- lexical-binding: t; -*-

;; Personal configuration ported from the Bedrock init.el. Anything an enabled
;; Doom module already handles (the vertico/corfu stack, evil-collection, magit,
;; dirvish, envrc, org-roam autosync) is deliberately not repeated here.

;; Set before anything else: org lazy-loads, and several org/notes commands read
;; `org-directory' the moment they run. Setting it first also means a later
;; load-time error in this file can't leave it at Doom's ~/org default.
(setq org-directory "~/nb/org/")

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

;;; Evil --------------------------------------------------------------------

;; Terminal buffers need keystrokes passed straight to the underlying program,
;; so start them in Evil's emacs state rather than normal state.
(after! evil
  (evil-set-initial-state 'eat-mode 'emacs)
  (evil-set-initial-state 'vterm-mode 'emacs)
  ;; Commit messages should open ready to type.
  (add-hook 'git-commit-setup-hook #'evil-insert-state))

;;; Leader key --------------------------------------------------------------

;; Ported from the general.el leader-def. Several of these prefixes overlap
;; Doom's own richer defaults (SPC f, SPC g, SPC p, SPC w, SPC h) -- these
;; overrides trade Doom's extra commands for the exact Bedrock layout. Drop a
;; prefix block to fall back to Doom's version.
(map! :leader
      :desc "M-x"       "SPC" #'execute-extended-command
      :desc "Find file" "."   #'find-file
      :desc "M-x"       ":"   #'execute-extended-command

      (:prefix ("f" . "find")
       :desc "file"             "f" #'find-file
       :desc "recent file"      "r" #'consult-recent-file
       :desc "grep"             "g" #'consult-ripgrep
       :desc "buffer"           "b" #'consult-buffer
       :desc "symbol"           "s" #'consult-imenu
       :desc "symbol (project)" "S" #'consult-imenu-multi
       :desc "diagnostics"      "d" #'consult-flymake)

      (:prefix ("b" . "buffer")
       :desc "switch"   "b" #'consult-buffer
       :desc "kill"     "d" #'kill-current-buffer
       :desc "previous" "[" #'previous-buffer
       :desc "next"     "]" #'next-buffer)

      (:prefix ("c" . "code")
       :desc "action" "a" #'eglot-code-actions)

      (:prefix ("r" . "refactor")
       :desc "rename" "n" #'eglot-rename
       :desc "format" "f" #'eglot-format)

      (:prefix ("d" . "diagnostics")
       :desc "list"     "l" #'consult-flymake
       :desc "next"     "]" #'flymake-goto-next-error
       :desc "previous" "[" #'flymake-goto-prev-error)

      (:prefix ("e" . "explorer")
       :desc "here" "e" #'dired-jump)

      (:prefix ("g" . "git")
       :desc "status" "g" #'magit-status
       :desc "blame"  "b" #'magit-blame)

      (:prefix ("p" . "project")
       :desc "switch"    "p" #'project-switch-project
       :desc "find file" "f" #'project-find-file
       :desc "buffer"    "b" #'project-switch-to-buffer)

      (:prefix ("s" . "search")
       :desc "line"         "s" #'consult-line
       :desc "project grep" "p" #'consult-ripgrep)

      (:prefix ("w" . "window")
       :desc "other"       "w" #'other-window
       :desc "delete"      "d" #'delete-window
       :desc "only"        "o" #'delete-other-windows
       :desc "split below" "s" #'split-window-below
       :desc "split right" "v" #'split-window-right)

      (:prefix ("t" . "tab")
       :desc "new"      "n" #'tab-new
       :desc "close"    "q" #'tab-close
       :desc "previous" "[" #'tab-previous
       :desc "next"     "]" #'tab-next)

      (:prefix ("h" . "help")
       :desc "key"      "k" #'describe-key
       :desc "function" "f" #'describe-function
       :desc "variable" "v" #'describe-variable
       :desc "mode"     "m" #'describe-mode)

      (:prefix ("o" . "org")
       :desc "agenda"     "a" #'org-agenda
       :desc "capture"    "c" #'org-capture
       :desc "store link" "l" #'org-store-link
       (:prefix ("r" . "roam")
        :desc "find node"   "f" #'org-roam-node-find
        :desc "insert link" "i" #'org-roam-node-insert
        :desc "backlinks"   "b" #'org-roam-buffer-toggle
        :desc "capture"     "c" #'org-roam-capture
        :desc "today"       "t" #'org-roam-dailies-goto-today
        :desc "prev daily"  "[" #'org-roam-dailies-goto-previous-note
        :desc "next daily"  "]" #'org-roam-dailies-goto-next-note))

      (:prefix ("q" . "quit")
       :desc "quit emacs" "q" #'save-buffers-kill-terminal))

;;; Tree-sitter majors ------------------------------------------------------

;; Grammars come from treesit-grammars.with-all-grammars (home/emacs.nix). Doom's
;; :tools tree-sitter module is intentionally off; this mirrors the Bedrock
;; built-in remapping instead.
(setq major-mode-remap-alist
      '((yaml-mode   . yaml-ts-mode)
        (sh-mode     . bash-ts-mode)
        (js-mode     . js-ts-mode)
        (json-mode   . json-ts-mode)
        (css-mode    . css-ts-mode)
        (python-mode . python-ts-mode)))
(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))

;;; Eglot -------------------------------------------------------------------

(after! eglot
  (setq eglot-send-changes-idle-time 0.1
        eglot-extend-to-xref t)
  (fset #'jsonrpc--log-event #'ignore)  ; large perf win: skip logging every event

  (add-to-list 'eglot-server-programs '((nix-mode nix-ts-mode) . ("nixd")))
  (add-to-list 'eglot-server-programs '(fennel-mode . ("fennel-ls")))
  (add-to-list 'eglot-server-programs '(janet-mode . ("janet-lsp")))

  ;; Point nixd at this flake so it completes nixpkgs attrs plus NixOS and
  ;; home-manager options for this machine's nixosConfigurations entry.
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

  (add-to-list 'completion-category-overrides '(eglot (styles orderless)))
  (add-to-list 'completion-category-overrides '(eglot-capf (styles orderless))))

;; Extra eglot-managed majors beyond the ones Doom's +lsp flags cover.
(add-hook! '(clojure-mode-hook clojurescript-mode-hook clojurec-mode-hook
             fennel-mode-hook janet-mode-hook)
           #'eglot-ensure)

;;; Lisp editing (parinfer) -------------------------------------------------

;; The Rust core is built by Nix; PARINFER_RUST_LIBRARY is exported from
;; home/emacs.nix so we never auto-download it.
(use-package! parinfer-rust-mode
  :init
  (setq parinfer-rust-auto-download nil
        parinfer-rust-dim-parens nil
        parinfer-rust-preferred-mode "smart"
        parinfer-rust-disable-troublesome-modes t)
  (when-let ((lib (getenv "PARINFER_RUST_LIBRARY")))
    (setq parinfer-rust-library lib))
  :hook ((emacs-lisp-mode lisp-mode lisp-data-mode
          clojure-mode fennel-mode janet-mode) . parinfer-rust-mode))

(after! cider
  (setq cider-repl-display-help-banner nil))

;;; Terminals with inline graphics -----------------------------------------

;; ghostel (libghostty terminal) and kitty-graphics are built by Nix and put on
;; the load-path via extraPackages, so they're `require'-able without a package!.
(use-package! ghostel
  :commands ghostel)

(use-package! kitty-graphics
  :unless (display-graphic-p)
  :config (kitty-graphics-setup))

;;; Org ---------------------------------------------------------------------
;; (org-directory is set at the top of this file.)

(after! org
  (setq org-agenda-files '("inbox.org")
        ispell-program-name "aspell"
        org-confirm-babel-evaluate nil
        org-export-with-smart-quotes t
        org-outline-path-complete-in-steps nil
        org-refile-use-outline-path 'file)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w@/!)" "STARTED(s!)" "|" "DONE(d!)" "OBSOLETE(o@)")))

  (setq org-tag-alist '((:startgroup)
                        ("home" . ?h) ("work" . ?w) ("school" . ?s)
                        (:endgroup)
                        (:newline)
                        (:startgroup)
                        ("one-shot" . ?o) ("project" . ?j) ("tiny" . ?t)
                        (:endgroup)
                        ("meta") ("review") ("reading")))

  (setq org-refile-targets '((nil :maxlevel . 3)
                             (org-agenda-files :maxlevel . 3)))

  (setq org-capture-templates
        '(("c" "Default Capture" entry (file "inbox.org")
           "* TODO %?\n%U\n%i")
          ("r" "Capture with Reference" entry (file "inbox.org")
           "* TODO %?\n%U\n%i\n%a")
          ("w" "Work")
          ("wm" "Work meeting" entry (file+headline "work.org" "Meetings")
           "** TODO %?\n%U\n%i\n%a")
          ("wr" "Work report" entry (file+headline "work.org" "Reports")
           "** TODO %?\n%U\n%i\n%a")))

  (setq org-agenda-custom-commands
        '(("n" "Agenda and All Todos" ((agenda) (todo)))
          ("w" "Work" agenda "" ((org-agenda-files '("work.org"))))))

  (require 'oc-csl)
  (add-to-list 'org-export-backends 'md)
  (setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (shell . t) (python . t)
     (clojure . t) (fennel . t) (d2 . t)))

  ;; Babel backends spawn interpreters in fresh buffers that lose the org
  ;; buffer's buffer-local envrc PATH; propagate it across the single execution
  ;; entry point so every backend inherits it.
  (inheritenv-add-advice 'org-babel-execute-src-block))

(add-hook! 'org-mode-hook #'flyspell-mode)

;;; org-modern + Evil-driven pretty/raw toggle ------------------------------

(use-package! org-modern
  :after org
  :init
  (setq org-auto-align-tags nil
        org-tags-column 0
        org-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-modern-star 'replace
        org-agenda-tags-column 0
        org-ellipsis "…")
  (setq org-modern-checkbox
        `((?\s . ,(char-to-string #xF0131))
          (?-  . ,(char-to-string #xF06F2))
          (?X  . ,(char-to-string #xF0132))))
  :config
  (setq-default line-spacing 0.1)
  (global-org-modern-mode))

;; In non-insert Evil states show org-modern's pretty styling; on entering
;; insert state drop the whole buffer to a raw markup view, restored on exit.
(defun +org-set-pretty (pretty)
  (when (derived-mode-p 'org-mode)
    (setq-local org-hide-emphasis-markers pretty
                org-pretty-entities pretty
                org-link-descriptive pretty
                org-fontify-emphasized-text pretty)
    (org-modern-mode (if pretty 1 -1))
    (font-lock-flush)))

(after! evil
  (add-hook 'evil-insert-state-entry-hook (lambda () (+org-set-pretty nil)))
  (add-hook 'evil-insert-state-exit-hook  (lambda () (+org-set-pretty t))))

;;; org-roam ----------------------------------------------------------------

;; :lang org +roam2 pulls in org-roam and autosync; just point it at the dir.
(setq org-roam-directory (file-name-as-directory
                          (expand-file-name "roam" org-directory))
      org-roam-database-connector 'sqlite-builtin)

;;; AI agent shell ----------------------------------------------------------

;; Spawns claude-agent-acp (provided by Nix).
(use-package! agent-shell
  :commands agent-shell)
