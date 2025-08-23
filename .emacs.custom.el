(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(amx-auto-update-interval 10)
 '(amx-history-length 30)
 '(auto-revert-verbose nil)
 '(compile-command "")
 '(confirm-kill-emacs 'y-or-n-p)
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
     default))
 '(delete-selection-mode t)
 '(display-line-numbers-type 'relative)
 '(global-auto-revert-non-file-buffers t)
 '(ido-completion-buffer-all-completions t)
 '(ido-cr+-replace-completely t)
 '(org-agenda-dim-blocked-tasks nil)
 '(org-agenda-exporter-settings '((org-agenda-tag-filter-preset (list "+personal"))))
 '(org-cliplink-transport-implementation 'url-el)
 '(org-enforce-todo-dependencies nil)
 '(org-modules
   '(org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc
              org-mhe org-rmail org-w3m))
 '(org-refile-use-outline-path 'file)
 '(package-selected-packages nil)
 '(safe-local-variable-values
   '((eval progn (auto-revert-mode 1) (rc/autopull-changes)
           (add-hook 'after-save-hook 'rc/autocommit-changes nil
                     'make-it-local))))
 '(warning-minimum-level :error)
 '(whitespace-style
   '(face tabs spaces trailing space-before-tab newline indentation empty
          space-after-tab space-mark tab-mark)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
  
