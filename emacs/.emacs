;;; This config based-on Tsoding emacs config  -*- lexical-binding: t; -*-
;;  https://github.com/rexim/dotfiles

;; Maximize GC threshold during startup to speed up boot time, then reset it.
(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))))

;; Disable UI elements immediately to prevent flashing
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq frame-inhibit-implied-resize t)
(setq inhibit-splash-screen t)

(add-to-list 'default-frame-alist '(font . "Iosevka 26"))

;; Package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t
      package-install-upgrade-built-in t)

;; Core emacs configuration
(use-package emacs
  :init
  (setq-default custom-file (expand-file-name "~/.emacs.custom.el"))
  (when (file-exists-p custom-file)
    (load custom-file))

  ;; Native Compilation Settings
  (setq cpu-architecture "znver4")
  (setq-default native-comp-compiler-options
                `("-O2"
                  ,(format "-mtune=%s" cpu-architecture)
                  ,(format "-march=%s" cpu-architecture)
                  "-g0"
                  "-fno-omit-frame-pointer"
                  "-fno-finite-math-only"))

  (setq-default native-comp-driver-options '("-Wl,-z,pack-relative-relocs"
                                             "-Wl,-O2"
                                             "-Wl,--as-needed"))
  ;; Core variables
  (setq-default make-backup-files nil
                tab-width 4
                indent-tabs-mode nil
                disabled-command-function 'ignore
                pgtk-wait-for-event-timeout 0
                c-basic-offset 4
                c-default-style '((java-mode . "java")
                                  (awk-mode . "awk")
                                  (other . "bsd")))

  (setq yas-snippet-dirs '("~/.emacs.snippets/"))

  :config
  (column-number-mode 1)
  (show-paren-mode 1)
  (global-display-line-numbers-mode)

  ;; Misc core keybindings
  (global-set-key (kbd "C-,") #'duplicate-line)
  (global-set-key (kbd "C-x C-g") #'find-file-at-point))

;; Auto Revert (Built-in)
(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode 1)
  (setq global-auto-revert-non-file-buffers t))

;; Dired (Built-in)
(use-package dired
  :ensure nil
  :config
  (require 'dired-x)
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$")
        dired-dwim-target t
        dired-listing-switches "-ahv"
        dired-mouse-drag-files t))

;; Compilation (Built-in)
(use-package compile
  :ensure nil
  :bind ("M-C-g" . recompile)
  :config
  (add-to-list 'compilation-error-regexp-alist
               '("\\([^()\n]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?" 1 2 (4) (5)))
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))

;; Whitespace Handling
(use-package whitespace
  :ensure nil
  :config
  (setq whitespace-style '(face tabs spaces trailing space-before-tab newline
                                indentation empty space-after-tab space-mark tab-mark))

  (defun rc/set-up-whitespace-handling ()
    (interactive)
    (whitespace-mode 1)
    (add-to-list 'write-file-functions #'delete-trailing-whitespace))

  (add-hook 'prog-mode-hook #'rc/set-up-whitespace-handling)
  (add-hook 'text-mode-hook #'rc/set-up-whitespace-handling))

;; External packages & ui
(use-package gruber-darker-theme
  :ensure nil
  :load-path "~/.emacs.local/"
  :config
  (load-theme 'gruber-darker t))

(use-package icomplete
  :ensure nil ;; Built-in
  :custom
  (icomplete-separator " | ")
  (icomplete-prospects-prefix "{")
  (icomplete-prospects-suffix "}")
  :config
  (fido-mode 1)
  (add-hook 'icomplete-minibuffer-setup-hook
            (lambda ()
              (setq-local completion-styles '(substring basic)))))

(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("C-\""        . mc/skip-to-next-like-this)
         ("C-:"         . mc/skip-to-previous-like-this)))

(use-package paredit
  :hook ((emacs-lisp-mode lisp-mode common-lisp-mode
          clojure-mode scheme-mode racket-mode) . paredit-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto-prefix 4)
  (corfu-auto-trigger ".")
  (corfu-on-exact-match 'quit)
  (corfu-sort-function nil)
  (corfu-auto t))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

;; Language modes & tools
(use-package d-mode :defer t)
(use-package rust-mode :defer t)
(use-package markdown-mode :defer t)
(use-package meson-mode :defer t)

(use-package transient)
(use-package magit
  :defer t
  :after transient)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package simpc-mode
  :ensure nil
  :load-path "~/.emacs.local/"
  :mode (("\\.[hc]\\(pp\\)?\\'" . simpc-mode)
         ("\\.[b]\\'" . simpc-mode)))

(use-package lua-mode
  :defer t
  :custom
  (lua-indent-level 2)
  (lua-indent-close-paren-align nil))

(use-package my-misc
  :ensure nil
  :load-path "~/.emacs.local/")
