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
       hl-line
       (modeline +light)  ; replaces spaceline; swap for a `package! spaceline' if you miss it
       ophints
       (popup +defaults)
       vc-gutter
       window-select      ; SPC w w candidate picker
       workspaces         ; persp-based; Bedrock used tab-bar (see leader "t" map in config.el)

       :editor
       (evil +everywhere) ; evil + evil-collection across built-in and third-party modes
       fold
       word-wrap

       :emacs
       (dired +dirvish +icons)   ; dirvish-override-dired-mode
       electric                  ; electric-pair-mode
       undo
       vc

       :term
       eshell

       :checkers
       (syntax +flymake)  ; Bedrock drove flymake; not flycheck
       (spell +aspell)    ; flyspell via aspell (provided by Nix)

       :tools
       direnv             ; envrc
       (eval +overlay)
       lookup
       (lsp +eglot)       ; eglot, not lsp-mode -- matches the Bedrock setup
       magit

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       clojure            ; clojure-mode + cider
       data               ; yaml, json, csv majors
       emacs-lisp
       (javascript +lsp)  ; js/ts/tsx
       (lua +lsp)
       markdown
       (nix +lsp)
       (org +roam2 +dragndrop +pretty)
       (python +lsp)
       (sh +lsp)

       :config
       (default +bindings +smartparens))
