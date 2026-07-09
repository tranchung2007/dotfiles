;;; This config based-on Tsoding emacs config  -*- lexical-binding: t; -*-
;;  https://github.com/rexim/dotfiles

(defvar default-file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist default-file-name-handler-alist)))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))

(setq use-package-always-ensure t
      package-install-upgrade-built-in t)

(use-package emacs
  :ensure nil
  :custom
  (frame-inhibit-implied-resize t)
  (inhibit-compacting-font-caches t)
  (redisplay-dont-pause t)
  (inhibit-splash-screen t)
  (bidi-inhibit-bpa t)
  (redisplay-skip-fontification-on-input t)
  (bidi-paragraph-direction 'left-to-right)
  (use-file-dialog nil)
  (native-comp-compiler-options '("-O3" "-mtune=znver4" "-march=znver4" "-g0"
                                  "-fno-omit-frame-pointer" "-fno-finite-math-only"))
  (native-comp-driver-options '("-Wl,-z,pack-relative-relocs" "-Wl,-O2" "-Wl,--as-needed"))
  (pgtk-wait-for-event-timeout 0)
  (make-backup-files nil)
  (tab-width 4)
  (indent-tabs-mode nil)
  (c-basic-offset 4)
  (c-default-style '((java-mode . "java")
                     (awk-mode . "awk")
                     (other . "bsd")))
  (disabled-command-function 'ignore)
  (custom-file (expand-file-name "~/.emacs.custom.elc"))
  (yas-snippet-dirs '("~/.emacs.snippets/"))
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (column-number-mode 1)
  (show-paren-mode 1)
  (global-display-line-numbers-mode 1)
  (add-to-list 'default-frame-alist '(font . "Iosevka 26"))
  (when (file-exists-p custom-file)
    (load custom-file))
  (global-set-key (kbd "C-,") #'duplicate-dwim)
  (global-set-key (kbd "C-x C-g") #'find-file-at-point))

(use-package autorevert
  :ensure nil
  :custom
  (global-auto-revert-non-file-buffers t)
  :config
  (global-auto-revert-mode 1))

(use-package dired
  :ensure nil
  :custom
  (dired-dwim-target t)
  (dired-listing-switches "-alhv")
  (dired-mouse-drag-files t))

(use-package dired-x
  :ensure nil
  :after dired
  :config
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$")))

(use-package compile
  :ensure nil
  :bind ("M-C-g" . recompile)
  :config
  (add-to-list 'compilation-error-regexp-alist
               '("\\([^()\n]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?" 1 2 (4) (5)))
  (add-hook 'compilation-filter-hook 'ansi-color-compilation-filter))

(use-package whitespace
  :ensure nil
  :hook ((prog-mode text-mode) . rc/set-up-whitespace-handling)
  :custom
  (whitespace-style '(face tabs spaces trailing space-before-tab newline
                      indentation empty space-after-tab space-mark tab-mark))
  :config
  (defun rc/set-up-whitespace-handling ()
    (whitespace-mode 1)
    (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))

(use-package gruber-darker-theme
  :ensure nil
  :load-path "~/.emacs.local/"
  :config
  (load-theme 'gruber-darker t))

(use-package icomplete
  :ensure nil
  :hook (after-init . fido-mode)
  :custom
  (icomplete-separator " | ")
  (icomplete-prospects-prefix "{")
  (icomplete-prospects-suffix "}")
  :config
  (add-hook 'icomplete-minibuffer-setup-hook
            (lambda ()
              (setq-local completion-styles '(basic initials partial-completion substring)))))

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
          clojure-mode scheme-mode racket-mode)
         . paredit-mode))

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-on-exact-match 'quit)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary t)
  (corfu-preview-current nil))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(use-package d-mode :defer t)
(use-package rust-mode :defer t)
(use-package cmake-mode :defer t)
(use-package meson-mode :defer t)
(use-package markdown-mode :defer t)

(use-package transient
  :defer t)

(use-package magit
  :defer t
  :after transient)

(use-package yasnippet
  :hook (after-init . yas-global-mode))

;; (use-package simpc-mode
;;   :ensure nil
;;   :load-path "~/.emacs.local/"
;;   :mode (("\\.[hc]\\(pp\\)?\\'" . simpc-mode)
;;          ("\\.[b]\\'" . simpc-mode)))

(use-package lua-mode
  :defer t)

(use-package my-misc
  :ensure nil
  :load-path "~/.emacs.local/")
