;;; init.el -*- lexical-binding: t; -*-

;; Doom module manifest. Each enabled module replaces a chunk of the hand-rolled
;; Bedrock init.el: the completion stack, evil, dired/dirvish, eglot, magit,
;; direnv, the language majors, and org all come from here rather than from
;; individual use-package forms. Personal settings and keybindings that Doom
;; doesn't cover live in config.el; packages Doom doesn't ship in packages.el.
;;
;; Under nix-doom-emacs-unstraightened these flags decide what Nix builds --
;; there is no `doom sync'. After changing this file, rebuild home-manager.

(doom! :completion
       vertico            ; vertico + consult + embark + marginalia + orderless + wgrep
       corfu              ; corfu + cape + corfu-popupinfo + kind-icon (+ terminal popup)

       :ui
       doom               ; doom-themes
       doom-dashboard
       hl-todo
       modeline
       nav-flash
       ophints
       (popup +defaults)
       smooth-scroll
       tabs
       window-select
       workspaces

       :editor
       (evil +everywhere) ; evil + evil-collection across built-in and third-party modes
       file-templates
       fold

       :emacs
       (dired +dirvish +icons)   ; dirvish-override-dired-mode
       electric
       undo
       vc

       :term
       eshell
       term
       vterm
       ;;ghostel

       :tools
       direnv
       (eval +overlay)
       lookup
       (lsp +eglot)
       magit
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       clojure            ; clojure-mode + cider
       data               ; yaml, json, csv majors
       emacs-lisp
       janet
       (javascript +lsp)  ; js/ts/tsx
       latex
       (lua +lsp)
       markdown
       (nix +lsp)
       (org +roam +dragndrop +pretty)
       (python +lsp)
       (sh +lsp)

       :config
       literate
       (default +bindings +smartparens))
