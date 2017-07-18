;;; ui-common-conf.el --- Summary

;;; Commentary:
;;; UI settings common for all modes

;;; Code:

(require 'dired)
(require 'neotree)
(require 'powerline)
(require 'sr-speedbar)
(require 'all-the-icons)
;; (require 'smooth-scroll)

;; Disable welcom screen
(setq inhibit-splash-screen   t)
(setq inhibit-startup-message t)

;; Remove some GUI elelements
(tooltip-mode      -1)
(menu-bar-mode     -1)
(tool-bar-mode     -1)
(scroll-bar-mode   -1)
(setq ring-bell-function 'ignore)

;; Use 'y' and `n' instead of 'yes' and 'not'
(fset 'yes-or-no-p 'y-or-n-p)

;; Name of current buffer in window title
(setq frame-title-format "GNU Emacs: %b")

;; Display file size/time in mode-line
;; (display-time-mode t) ;; Show time in mode-line
(size-indication-mode t)

;; Frienge settings
;; The fringe is a thin strip down the left and/or right edge of a window.
(fringe-mode '(0 . 0)) ;; limited just to the left of the text
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; Current buffer size
(size-indication-mode nil)

;; Fullscreen at startup
(defun fullscreen ()
    "Make Emacs fullscreen at the start."
    (interactive)
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                           '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
    (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                           '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))
(when (window-system) (fullscreen))

;; Smooth scroll
;; (smooth-scroll-mode t)

;; (setq scroll-step 1)
;; (setq scroll-margin 1)
;; (setq scroll-conservatively 10000)
;; (setq mouse-wheel-follow-mouse 't)
;; (setq scroll-preserve-screen-position t)
;; (setq mouse-wheel-progressive-speed nil)
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;; Disable cursor blink
(blink-cursor-mode 0)

;; Movement between windows with M-arrow-keys M-arrow-keys (except org-mode)
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))

;; Dired (C-x D)
;; Dired makes an Emacs buffer containing a listing of a directory,
;; and optionally some of its subdirectories as well.
(setq dired-recursive-deletes 'top) ;; for deleting of empty dirs

;; Speedbar
(add-hook 'speedbar-mode-hook
          (lambda ()
              (speedbar-change-initial-expansion-list "quick buffers")))
(setq sr-speedbar-width 40)
(global-set-key (kbd "<f5>") 'sr-speedbar-open)

;; NeoTree
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

(provide 'ui-common-conf)
;;; ui-common-conf.el ends here
