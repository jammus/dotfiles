;;; early-init.el --- Loaded before init.el and GUI setup -*- lexical-binding: t; -*-

;;; Bedrock early-init, adapted for a Nix-provisioned package set.

;; Startup speed, annoyance suppression
(setq bedrock--initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold 10000000)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Silence stupid startup message
(setq inhibit-startup-echo-area-message (user-login-name))

;; Default frame configuration: full screen, good-looking title bar on macOS
(setq frame-resize-pixelwise t)

(when (boundp 'tool-bar-mode) ; When in a GUI, disable tool bar;
  (tool-bar-mode -1))         ; all these tools are in the menu-bar anyway

(setq default-frame-alist '((fullscreen . maximized)

                            ;; Setting the face in here prevents flashes of
                            ;; color as the theme gets activated
                            (background-color . "#000000")
                            (foreground-color . "#ffffff")
                            (ns-appearance . dark)
                            (ns-transparent-titlebar . t)))
