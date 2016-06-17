
(defun on-frame-creating ()
  "This function sets font faces and other that not setted on starting emacs daemon"
  (load-theme 'deeper-blue t)
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:family "Hack" :foundry "unknown" :slant normal :weight normal :height 90 :width normal))))) 
  (toggle-frame-fullscreen))

;; (cons after-make-frame-functions '(on-frame-creating))
;; after-make-frame-functions
;; (setq after-make-frame-functions '(x-dnd-init-frame toggle-frame-fullscreen))
;; (add-to-list 'after-make-frame-functions
;; 	     'on-frame-creating)
(if (window-system)
   (on-frame-creating))

(add-hook 'after-make-frame-functions
	  #'(lambda (f)
	      (with-selected-frame f (on-frame-creating))))

;;(toggle-input-method 'russian-coomputer)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default-input-method 'russian-computer)
 '(c-default-style "stroustrup" t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize) ;; You might already have this line

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)

(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers))
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

(define-key global-map (kbd "C-c ;") 'iedit-mode)

;(defun my:flymake-google-init ()
;  (require 'flymake-google-cpplint)
;  (custom-set-variables
;   '(flymake-google-cpplint-command "/usr/bin/cpplint"))
;  (flymake-google-cpplint-load)
;)
;(add-hook 'c-mode-hook 'my:flymake-google-init)
;(add-hook 'c++-mode-hook 'my:flymake-google-init)

(semantic-mode 1)
(defun my:add-semantic-to-autocomplete()
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)

(global-ede-mode 1)
(global-semantic-idle-scheduler-mode 1)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(require 'irony)

;

;(setq c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "gnu")))
(setq c-basic-offset 4)
(setq default-frame-alist
      (append
       (list '(width . 150) ; Width set to 81 characters
	     '(height . 45)) ; Height set to 60 lines
       default-frame-alist))

(column-number-mode 1)
(display-battery-mode 1)
(display-time-mode 1)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(setq c-default-style "stroustrup")

(setq show-paren-style 'expression )
(show-paren-mode 2)


(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; (unless (require 'el-get nil 'noerror)
;;   (with-current-buffer
;;       (url-retrieve-synchronously
;;        "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;;     (let (el-get-master-branch)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp))))
;; (el-get 'sync)

;; (require 'ido)
;; (ido-mode t)
;; (add-hook 'python-mode-hook 'auto-complete-mode)
;; (add-hook 'python-mode-hook 'jedi:ac-setup)
;; (add-hook 'after-save-hook #'global-flycheck-mode)
;; (require 'autopair)
;; (autopair-global-mode)

(elpy-enable)
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
(define-key global-map (kbd "C-c o") 'iedit-mode)
(shell-command "xmodmap ~/.Xmodmap")
;; C-M-a
;; C-M-d - down-list
