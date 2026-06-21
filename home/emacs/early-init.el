;;; early-init.el --- Loaded before init.el and GUI setup -*- lexical-binding: t; -*-

;;; Bedrock early-init, adapted for a Nix-provisioned package set.

;; Startup speed, annoyance suppression
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Redisplay performance: skip bidirectional-text reordering for LTR content,
;; and defer fontification while input is pending.
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
(setq redisplay-skip-fontification-on-input t)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration: full screen, good-looking title bar on macOS
(setq frame-resize-pixelwise t)

(when (boundp 'tool-bar-mode) ; When in a GUI, disable tool bar;
  (tool-bar-mode -1))         ; all these tools are in the menu-bar anyway

(setq default-frame-alist '((fullscreen . maximized)

                            ;; Setting the face in here prevents flashes of
                            ;; color as the theme gets activated
                            (background-color . "#292828")
                            (foreground-color . "#d4be98")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)))
