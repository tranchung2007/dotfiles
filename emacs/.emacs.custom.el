;; -*- lexical-binding: t; -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-revert-avoid-polling t)
 '(auto-revert-verbose nil)
 '(backup-directory-alist '(("." . "~/.emacs.d/backups/")))
 '(bidi-paragraph-direction 'left-to-right)
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(company-backends
   '(company-semantic company-cmake company-capf company-files
                      (company-dabbrev-code company-gtags
                                            company-etags
                                            company-keywords)
                      company-dabbrev))
 '(company-dabbrev-code-ignore-case t)
 '(company-dabbrev-downcase nil)
 '(compilation-always-kill t)
 '(confirm-kill-emacs 'y-or-n-p)
 '(create-lockfiles nil)
 '(custom-safe-themes
   '("31818c3d9a77ea73dfdce82f46c720f0161696dc899a580eac8b1e5dbbb21694"
     default))
 '(delete-selection-mode t)
 '(dired-auto-revert-buffer t)
 '(dired-clean-confirm-killing-deleted-buffers nil)
 '(dired-do-revert-buffer t)
 '(dired-kill-when-opening-new-dired-buffer t)
 '(dired-recursive-copies 'always)
 '(dired-recursive-deletes 'top)
 '(disabled-command-function 'ignore t)
 '(display-line-numbers-type 'relative)
 '(duplicate-line-final-position -1)
 '(electric-pair-mode t)
 '(fast-but-imprecise-scrolling t)
 '(font-lock-maximum-decoration 2)
 '(global-auto-revert-mode t)
 '(global-display-line-numbers-mode t)
 '(global-eldoc-mode nil)
 '(grep-find-command '("rg --no-heading --color=never -nSe ''" . 37))
 '(history-length 1000)
 '(icomplete-compute-delay 0)
 '(icomplete-separator " | ")
 '(ignored-local-variable-values '((elisp-autofmt-format-quoted)))
 '(indent-tabs-mode nil)
 '(make-backup-files nil)
 '(package-selected-packages
   '(cmake-mode company d-mode dtrt-indent gtags-mode lua-mode magit
                markdown-mode meson-mode move-text multiple-cursors
                paxedit rust-mode yaml-mode yasnippet))
 '(ring-bell-function 'ignore)
 '(safe-local-variable-values '((cmake-tab-width . 2)))
 '(show-paren-mode t)
 '(tab-width 4)
 '(truncate-lines t)
 '(use-short-answers t)
 '(yas-snippet-dirs '("~/.emacs.snippets/")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
