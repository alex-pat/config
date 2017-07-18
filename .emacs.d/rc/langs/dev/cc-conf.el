;;; cc-conf.el --- Summary

;;; Commentary:
;; Settings only for C/C++

;;; Code:
(require 'irony)
(require 'cc-mode)
(require 'company)
(require 'flycheck)
(require 'cmake-ide)
(require 'clang-format)
(require 'company-irony-c-headers)

;; Open headers for C in c-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))
;; Open headers for C++ in c++-mode
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))

(setq irony-server-install-prefix "~/.emacs.d/servers/Irony")
(defun my-irony-mode-hook()
    (define-key irony-mode-map [remap completion-at-point]
        'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
        'irony-completion-at-point-async)
    (irony-cdb-autosetup-compile-options)

    ;; (optional) adds CC special commands to
    ;; `company-begin-commands' in order to
    ;; trigger completion at interesting places, such as after
    ;; scope operator std::|
    (company-irony-setup-begin-commands))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

(eval-after-load 'flycheck '(add-hook 'flycheck-mode-hook
                             #'flycheck-irony-setup))

(defun my-cc-hook ()
    "Settings common for C and C++ modes."
    (irony-mode)
    (setq c-basic-offset 4)
    (add-to-list (make-local-variable 'company-backends)
                 '(company-irony-c-headers company-irony company-yasnippet))
    (add-hook 'write-contents-functions 'cleanup-buffer-notabs nil t)
    (hs-minor-mode)
    (local-set-key (kbd "C-c C-r") 'clang-format-region))

(defun my-c-mode-hook()
    (my-cc-hook)
    (setq c-default-style "stroustrup")
    (setq c-basic-offset 4)
    (setq tab-width 4)
    (setq indent-tabs-mode nil)
    (setq linux-kernel-style "\
{BasedOnStyle: LLVM, \
 IndentWidth: 8, \
 UseTab: Always, \
 BreakBeforeBraces: Linux, \
 AllowShortIfStatementsOnASingleLine: false,\
 IndentCaseLabels: false}")
    (setq clang-format-style linux-kernel-style))

(add-hook 'c-mode-hook 'my-c-mode-hook)

(defun my-c++-mode-hook()
    (my-cc-hook)
    (setq clang-format-style "webkit")
    (setq flycheck-clang-language-standard "c++14")
    (setq irony-additional-clang-options '("-std=c++14")))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

(cmake-ide-setup)
(setq cmake-ide-flags-c++ (append '("-std=c++14")))

(provide 'cc-conf)
;;; cc-conf.el ends here
