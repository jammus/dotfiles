;;; org-appear-line.el --- Whole-line Org markup reveal -*- lexical-binding: t; -*-

;;; Commentary:

;; A small local module (NOT a package) that emulates Vim's
;; conceallevel/concealcursor whole-line behaviour for Org markup: every
;; toggleable fragment on the line the cursor is on is revealed at once, and
;; re-hidden when the cursor leaves the line.
;;
;; It deliberately does NOT enable `org-appear-mode' (which reveals one element
;; at a time); instead it reuses org-appear's per-element show/hide internals
;; (`org-appear--show-with-lock', `org-appear--hide-invisible',
;; `org-appear--current-elem') and drives them over a whole line's worth of
;; fragments. So org-appear must be installed and its autospec/Org visibility
;; variables configured -- see the org-appear `use-package' block in init.el.
;;
;; Scope: this covers what org-appear covers -- emphasis markers, links,
;; entities, sub/superscripts, keywords. It does NOT touch org-modern's
;; overlays (headline/list bullets, tag pills, block delimiters); those are a
;; separate, overlay-based subsystem.

;;; Code:

(require 'org-appear)
(require 'org-element)

(defvar-local org-appear-line--prev-bol nil
  "Buffer position of the line beginning last processed.")

(defvar-local org-appear-line--tick nil
  "`buffer-chars-modified-tick' value when the line was last scanned.")

(defvar-local org-appear-line--shown nil
  "Toggleable elements currently revealed on the active line.")

(defun org-appear-line--elems ()
  "Return the toggleable Org elements intersecting the current line.
Walks the line, reusing `org-appear--current-elem' to recognise each
fragment org-appear knows how to toggle."
  (let ((end (line-end-position))
        (elems '()))
    (save-excursion
      (goto-char (line-beginning-position))
      (while (< (point) end)
        (if-let ((elem (org-appear--current-elem)))
            (progn
              (push elem elems)
              ;; Skip past this fragment so we don't report it repeatedly.
              (goto-char (max (1+ (point))
                              (org-element-property :end elem))))
          (forward-char 1))))
    (nreverse elems)))

(defun org-appear-line--reveal (elems)
  "Reveal each element in ELEMS.
`org-appear--show-with-lock' runs `font-lock-ensure' first so jit-lock
won't immediately re-hide the fragment."
  (dolist (elem elems)
    (org-appear--show-with-lock elem)))

(defun org-appear-line--conceal (elems)
  "Re-hide each element in ELEMS.
Each is re-derived from its start position the way `org-appear' does, so
shifted bounds don't leave stale markup showing."
  (save-excursion
    (dolist (elem elems)
      (when-let ((start (org-element-property :begin elem)))
        (goto-char start)
        (org-appear--hide-invisible (org-element-context))))))

(defun org-appear-line--post-cmd ()
  "Reveal the current line's markup; re-hide the previous line's on a move."
  (let ((bol (line-beginning-position))
        (tick (buffer-chars-modified-tick)))
    ;; Only do work when the cursor changed line or the buffer changed --
    ;; plain motion within the line leaves everything revealed and idle.
    (when (or (not (eql bol org-appear-line--prev-bol))
              (not (eql tick org-appear-line--tick)))
      (when (not (eql bol org-appear-line--prev-bol))
        (org-appear-line--conceal org-appear-line--shown)
        (setq org-appear-line--shown nil))
      (setq org-appear-line--prev-bol bol
            org-appear-line--tick tick)
      (let ((elems (org-appear-line--elems)))
        (org-appear-line--reveal elems)
        (setq org-appear-line--shown elems)))))

;;;###autoload
(define-minor-mode org-appear-line-mode
  "Reveal all Org markup on the cursor's current line, hidden elsewhere.
The whole-line analogue of Vim's conceallevel + concealcursor."
  :init-value nil :lighter nil :keymap nil
  (cond
   (org-appear-line-mode
    ;; Populate `org-appear-elements' from the autospec flags and Org's own
    ;; visibility variables, exactly as `org-appear-mode' would on enable.
    (org-appear--set-elements)
    (setq org-appear-line--prev-bol nil
          org-appear-line--tick nil
          org-appear-line--shown nil)
    (add-hook 'post-command-hook #'org-appear-line--post-cmd nil t))
   (t
    (org-appear-line--conceal org-appear-line--shown)
    (setq org-appear-line--shown nil
          org-appear-line--prev-bol nil
          org-appear-line--tick nil)
    (remove-hook 'post-command-hook #'org-appear-line--post-cmd t))))

(provide 'org-appear-line)
;;; org-appear-line.el ends here
