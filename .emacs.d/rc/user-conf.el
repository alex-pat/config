;;; user-conf.el --- Summary

;;; Commentary:
;; Personal settings

;;; Code:
;; User nick and email

;;; Font
;; Work when emacs running as server
(setq default-frame-alist '((font . "Hack-9")))
;; Not work when emacs running as server, but will work
;; if previous version bad
;; (setq default-frame-alist '((font . "Hack :: Regular: 10:: Cyrillic")))

;; Theme
(load-theme 'spacemacs-dark t)

(require 'spaceline-config)
;; Themes: arrow, arrow-fade, bar, box, brace,
;; butt, chamfer, contour, curve,
;; rounded, roundstub, slant, wave, zigzag, nil,
(setq powerline-default-separator 'slant)

(spaceline-emacs-theme)
(spaceline-toggle-buffer-size-off)
(setq powerline-height 15)

(provide 'user-conf.el)
;;; user-conf.el ends here
