;;; Appearance
(defun rc/get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Consolas-13")
   ((eq system-type 'gnu/linux) "Iosevka-25")))

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))

(use-package emacs
  :init
  (setq custom-file "~/.emacs.custom.el")
  (load custom-file)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (column-number-mode 1)
  (show-paren-mode 1)
  (global-display-line-numbers-mode)
  (windmove-default-keybindings)
  (setq display-line-numbers-type (quote relative))
  (setq forward-sexp-function #'forward-sexp-default-function)
  )

(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

;;; dired
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alhv")
(setq dired-mouse-drag-files t)

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

(require 'compile)
compilation-error-regexp-alist-alist

(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(global-set-key (kbd "C-x C-g") 'find-file-at-point)
(setq-default inhibit-splash-screen t
              make-backup-files nil
              tab-width 4
              indent-tabs-mode nil)

;;; Whitespace mode
(setq whitespace-style
      (quote
       (face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark)))

(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'c++-mode-hook      'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook        'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook    'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode    'rc/set-up-whitespace-handling)
(add-hook 'tuareg-mode-hook   'rc/set-up-whitespace-handling)
(add-hook 'java-mode-hook     'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook      'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook     'rc/set-up-whitespace-handling)
(add-hook 'scala-mode-hook    'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'haskell-mode-hook  'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook   'rc/set-up-whitespace-handling)
(add-hook 'erlang-mode-hook   'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook      'rc/set-up-whitespace-handling)
(add-hook 'fasm-mode-hook     'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook       'rc/set-up-whitespace-handling)
(add-hook 'nim-mode-hook      'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook     'rc/set-up-whitespace-handling)
(add-hook 'porth-mode-hook    'rc/set-up-whitespace-handling)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t))

(use-package ido-completing-read+
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (ido-ubiquitous-mode 1))

(use-package amx
  :config
  (amx-mode 1))

(use-package crm-custom
  :config
  (crm-custom-mode 1))

(use-package move-text
  :bind (
         ("M-p" . move-text-up)
         ("M-n" . move-text-down)))

(use-package multiple-cursors
  :bind (
         ("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))

(defun rc/turn-on-paredit ()
  (interactive)
  (paredit-mode 1))

(use-package paredit
  :init
  (add-hook 'emacs-lisp-mode-hook  'rc/turn-on-paredit)
  (add-hook 'lisp-mode-hook        'rc/turn-on-paredit)
  (add-hook 'common-lisp-mode-hook 'rc/turn-on-paredit)
  (add-hook 'clojure-mode-hook     'rc/turn-on-paredit)
  (add-hook 'scheme-mode-hook      'rc/turn-on-paredit)
  (add-hook 'racket-mode-hook      'rc/turn-on-paredit))

(use-package simpc-mode
  :load-path "~/.emacs.local/"
  :init (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
  (add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode)))

(use-package company
  :init
  (global-company-mode 1))

(use-package rust-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun astyle-buffer (&optional justify)
  (interactive)
  let ((saved-line-number (line-number-at-pos)))
  (shell-command-on-region
   (point-min)
   (point-max)
   "astyle --style=kr"
   nil
   t)
  (goto-line saved-line-number))

(add-hook 'simpc-mode-hook
          (lambda ()
            (interactive)
            (setq-local fill-paragraph-function 'astyle-buffer)))

