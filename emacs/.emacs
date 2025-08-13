;;; Stolen from https://github.com/rexim/dotfiles
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
;; (fido-mode 1)

;;; relative line
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;;; Custom file
(setq custom-file "~/.emacs.custom.el")
(package-initialize)

(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")
;;(load "~/.emacs.rc/org-mode-rc.el")
;;(load "~/.emacs.rc/autocommit-rc.el")

(defun rc/get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Consolas-13")
   ((eq system-type 'gnu/linux) "Iosevka-16")))
(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))
(rc/require-theme 'gruber-darker)

;; ;; c-mode
;; (load "~/.emacs.rc/simpc-mode.el")
;; (require 'simpc-mode)
;; (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
;; (add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode))

;; ;;; External linter
;; (defun astyle-buffer (&optional justify)
;;   (interactive)
;;   (let ((saved-line-number (line-number-at-pos)))
;;     (shell-command-on-region
;;      (point-min)
;;      (point-max)
;;      "astyle --style=kr"
;;      nil
;;      t)
;;     (goto-line saved-line-number)))

;; (add-hook 'simpc-mode-hook
;;           (lambda ()
;;             (interactive)
;;             (setq-local fill-paragraph-function 'astyle-buffer)))

(setq major-mode-remap-alist
      '(( c-mode . c-ts-mode)
        '( c++-mode . c++-ts-mode)
        '( css-mode . css-ts-mode)
        ))

;;; dired
(require 'dired-x)
(setq dired-omit-files
(concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-Dalh")
(setq dired-mouse-drag-files t)

;;; Ido-mode
(rc/require 'amx 'ido-completing-read+ 'crm-custom)
(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(crm-custom-mode 1)
;; (setq magit-completing-read-function 'magit-ido-completing-read)
(amx-mode 1)

;;; Completion
(rc/require 'company)
(global-company-mode)
(add-hook 'tuareg-mode-hook
          (lambda ()
            (interactive)
            (company-mode 0)))

;;; Move Text
(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
;;(whitespace-mode 1)
(add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)

;;; electric-pair-mode
(defun rc/set-up-electric-pair ()
  (interactive)
  (electric-pair-local-mode 1))

(add-hook 'emacs-lisp-mode-hook 'rc/set-up-electric-pair)
(add-hook 'lisp-mode-hook 'rc/set-up-electric-pair)

;;; Plug that dont require config
(rc/require
 'lua-mode
 'cmake-mode
 'markdown-mode
 )

;;; word-wrap
(defun rc/enable-word-wrap ()
  (interactive)
  (toggle-word-wrap 1))

(add-hook 'markdown-mode-hook 'rc/enable-word-wrap)

;;; multiple cursors
(rc/require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:") 'mc/skip-to-previous-like-this)

;;; yasnippet
(rc/require 'yasnippet)
(require 'yasnippet)
(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(yas-global-mode 1)

;;; Compile
(require 'compile)
compilation-error-regexp-alist-alist
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(load-file custom-file)
