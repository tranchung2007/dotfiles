;;; This config based-on Tsoding emacs config  -*- lexical-binding: t; -*-
;;  https://github.com/rexim/dotfiles

;;; Appearance
(defun rc/get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Consolas-13")
   ((eq system-type 'gnu/linux) "Iosevka-25")))

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))

;; (set-face-attribute 'default nil :family "Px437 IBM VGA 8x16" :height 270)

(use-package emacs
  :init
  (setq custom-file "~/.emacs.custom.el")
  (load custom-file)
  ;; Stolen from https://www.jamescherti.com/compiling-emacs
  (setq my-cpu-architecture "znver4")
  (setq native-comp-compiler-options `("-O2"
                                       ,(format "-mtune=%s" my-cpu-architecture)
                                       ,(format "-march=%s" my-cpu-architecture)
                                       "-g0"
                                       "-fno-omit-frame-pointer"
                                       "-fno-finite-math-only"))

  (setq native-comp-driver-options '("-Wl,-z,pack-relative-relocs"
                                     "-Wl,-O2"
                                     "-Wl,--as-needed"))
  ;; Misc
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (column-number-mode 1)
  (show-paren-mode 1)
  (global-display-line-numbers-mode)
  (windmove-default-keybindings)
  (setq yas-snippet-dirs '("~/.emacs.snippets/"))
  (setq-default inhibit-splash-screen t
                make-backup-files nil
                tab-width 4
                indent-tabs-mode nil)
  (setq-default c-basic-offset 4
                c-default-style '((java-mode . "java")
                                  (awk-mode . "awk")
                                  (other . "bsd"))))

;;; dired
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alhv")
(setq dired-mouse-drag-files t)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
;; (setq auto-revert-interval 2)

;;; Stolen from https://lists.gnu.org/r/help-gnu-emacs/2010-01/msg00264.html
;; (add-hook 'dired-after-readin-hook
;;           (lambda ()
;;             (rename-buffer (generate-new-buffer-name dired-directory))))

(add-hook 'dired-after-readin-hook
          (lambda ()
            "Add a trailing slash to Dired buffer names."
            (let ((name (buffer-name)))
              (unless (string-suffix-p "/" name)
                (rename-buffer (concat name "/") t)))))

(global-set-key (kbd "C-,") #'duplicate-line)

(require 'compile)
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(global-set-key (kbd "C-x C-g") #'find-file-at-point)

;;; Whitespace mode
(setq whitespace-style
      (quote
       (face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark)))

(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'c++-mode-hook        #'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook          #'rc/set-up-whitespace-handling)
(add-hook 'd-mode-hook          #'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook      #'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode-hook #'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook       #'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook   #'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook     #'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook        #'rc/set-up-whitespace-handling)
(add-hook 'fasm-mode-hook       #'rc/set-up-whitespace-handling)

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
  (load-theme #'gruber-darker t))

(use-package ido-completing-read+
  :config
  (ido-mode 1)
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

(use-package markdown-mode)

(defun rc/turn-on-paredit ()
  (interactive)
  (paredit-mode 1))

(use-package paredit
  :config
  (add-hook 'emacs-lisp-mode-hook  #'rc/turn-on-paredit)
  (add-hook 'lisp-mode-hook        #'rc/turn-on-paredit)
  (add-hook 'common-lisp-mode-hook #'rc/turn-on-paredit)
  (add-hook 'clojure-mode-hook     #'rc/turn-on-paredit)
  (add-hook 'scheme-mode-hook      #'rc/turn-on-paredit)
  (add-hook 'racket-mode-hook      #'rc/turn-on-paredit))

;; (use-package company
;;   :config
;;   (global-company-mode 1))

(use-package corfu
  :init
  (global-corfu-mode)
  ;; for pgtk
  (setq-default pgtk-wait-for-event-timeout 0)
  (setq frame-inhibit-implied-resize t)
  :config
  (setq corfu-auto t
      corfu-auto-delay 0.2
      corfu-auto-trigger "." ;; Custom trigger characters
      corfu-quit-no-match 'separator))

(use-package cape
  :bind ("C-c p" . cape-prefix-map)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package rust-mode)

;; (use-package flycheck
;;   :init (global-flycheck-mode))

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package transient)

(use-package magit
  :after transient)

(use-package simpc-mode
  :load-path "~/.emacs.local/"
  :config (add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
  (add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode)))

(use-package d-mode)

(use-package dumb-jump
  :ensure t
  :custom
  (dumb-jump-prefer-searcher 'rg)
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq dumb-jump-rust-search-dependencies t))

(setq dumb-jump-extra-search-paths-function
      (lambda (lang proj-root)
        (cond
         ((member lang '("c" "cpp" "c++"))
          (delq nil
                (mapcar (lambda (dir) (when (file-directory-p dir) dir))
                        '("/usr/include" "/usr/local/include"))))

         ;; ((string= lang "rust")
         ;;  (let* ((cargo-registry (expand-file-name "~/.cargo/registry/src"))
         ;;         (sysroot (string-trim
         ;;                   (shell-command-to-string
         ;;                    "rustc --print sysroot 2>/dev/null || echo")))
         ;;         (rust-src (expand-file-name
         ;;                    "lib/rustlib/src/rust/library" sysroot)))
         ;;    (delq nil
         ;;          (mapcar (lambda (dir) (when (file-directory-p dir) dir))
         ;;                  (list cargo-registry rust-src)))))

         ((string= lang "dlang")
          (let ((dub-packages (expand-file-name "~/.dub/packages/")))
            (delq nil
                  (mapcar (lambda (dir) (when (file-directory-p dir) dir))
                          (list dub-packages
                                "/usr/include/dmd"
                                "/usr/include/dlang/dmd"
                                "/usr/include/dlang/ldc"
                                "/usr/lib/ldc/x86_64-redhat-linux-gnu/include/d/"))))))))
