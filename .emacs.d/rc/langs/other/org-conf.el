;;; org-conf --- Summary

;;; Commentary:
;; Settings only for org-mode

;;; Code:
(require 'org)
(require 'company)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-todo-keywords
      '((sequence "TODO" "SELECTED" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("SELECTED" . "red")))

(add-hook 'org-mode-hook
          (lambda ()
              (add-hook 'write-contents-functions
                        'cleanup-buffer-notabs nil t)))

(provide 'org-conf)
;;; org-conf.el ends here
