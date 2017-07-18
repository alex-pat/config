;;; latex-conf --- Summary

;;; Commentary:
;; Settings only for Latex

;;; Code:
(require 'preview)
(require 'tex-site)
(require 'company-auctex)

(setq TeX-PDF-mode t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

(add-hook 'LaTeX-mode-hook
          '(lambda ()
            (add-to-list (make-local-variable 'company-backends)
             '(company-math-symbols-latex company-latex-commands
               company-auctex-labels company-auctex-bibs
               company-auctex-macros company-auctex-symbols
               company-auctex-environments company-yasnippet))

            (define-key LaTeX-mode-map (kbd "$") 'self-insert-command)
            (add-hook 'write-contents-functions 'cleanup-buffer-notabs nil t)))

(provide 'latex-conf)
;;; latex-conf.el ends here
