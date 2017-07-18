;;; my-bindings --- Summary

;;; Commentary:
;;; Здесь лежит то, что я добавляю сам к конфигу гентушника

;;; Code:

;; jump-char aka vim's f command
(require 'jump-char)
(global-set-key (kbd "M-m") 'jump-char-forward)
(global-set-key (kbd "M-M") 'jump-char-backward)

;; ace-jump-mode aka easy-motion in vim
(require 'ace-jump-mode)
(define-key global-map (kbd "C-;") 'ace-jump-mode)

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; expand-region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; kill-whole-line
(global-set-key (kbd "M-k") 'kill-whole-line)

;; rust-mode formating on save
(setq rust-format-on-save t)
(setq rustfmt-bin "/home/postskript/.cargo/bin/rustfmt")

;; automatic update buffers on file update
(global-auto-revert-mode t)

;; rust hooks
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)

(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq racer-rust-src-path "/home/postskript/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")
(setq company-tooltip-align-annotations t)

(provide 'my-bindings)
;;; my-bindings.el ends here
