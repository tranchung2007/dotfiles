;; -*- lexical-binding: t; -*-

;; Highlight fido directory
(defun my-fido-highlight-directories (orig-fun &rest args)
  "Highlight directory file candidates and Dired buffers with the `dired-directory` face."
  (let* ((res (apply orig-fun args))
         (category (completion-metadata-get
                    (completion-metadata (nth 0 args) (nth 1 args) (nth 2 args))
                    'category)))
    (when (and res (memq category '(file buffer)))
      (let ((lst res))
        (while (consp lst)
          (let ((candidate (car lst)))
            (when (stringp candidate)
              (let ((is-dir (and (eq category 'file)
                                 (string-suffix-p "/" candidate)))
                    (is-dired-buf (and (eq category 'buffer)
                                       (let ((buf (get-buffer candidate)))
                                         (and buf
                                              (provided-mode-derived-p
                                               (buffer-local-value 'major-mode buf)
                                               'dired-mode))))))
                (when (or is-dir is-dired-buf)
                  (setcar lst (propertize (copy-sequence candidate) 'face 'dired-directory))))))
          (setq lst (cdr lst)))))
    res))

(advice-add 'completion-all-completions :around #'my-fido-highlight-directories)

;; Highlight the active directory path in the minibuffer input
(defvar-local my-minibuffer-path-overlay nil)
(defvar-local my-minibuffer-last-content nil)

(defun my-minibuffer-highlight-path-update ()
  "Update the overlay highlighting the directory path in the minibuffer."
  (let* ((beg (minibuffer-prompt-end))
         (end (point-max))
         (content (buffer-substring-no-properties beg end)))

    (unless (equal content my-minibuffer-last-content)
      (setq my-minibuffer-last-content content)

      (when (and minibuffer-completion-table
                 (eq (completion-metadata-get
                      (completion-metadata content
                                           minibuffer-completion-table
                                           minibuffer-completion-predicate)
                      'category)
                     'file))
        (let ((dir (file-name-directory content)))

          (unless my-minibuffer-path-overlay
            (setq my-minibuffer-path-overlay (make-overlay beg beg))
            (overlay-put my-minibuffer-path-overlay 'face 'dired-directory))

          (if dir
              (move-overlay my-minibuffer-path-overlay beg (+ beg (length dir)))
            (move-overlay my-minibuffer-path-overlay beg beg)))))))

(defun my-minibuffer-cleanup-path-highlight ()
  "Clean up the path highlight overlay when minibuffer exits."
  (when my-minibuffer-path-overlay
    (delete-overlay my-minibuffer-path-overlay)
    (setq my-minibuffer-path-overlay nil)))

(defun my-minibuffer-setup-path-highlight ()
  "Set up the path highlight hook for the current minibuffer."
  (setq my-minibuffer-last-content nil)
  (setq my-minibuffer-path-overlay nil)

  (add-hook 'post-command-hook #'my-minibuffer-highlight-path-update nil t)
  (add-hook 'minibuffer-exit-hook #'my-minibuffer-cleanup-path-highlight nil t))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-path-highlight)

;; Add / to dired directory buffer
(add-hook 'dired-after-readin-hook
          (lambda ()
            "Add a trailing slash to Dired buffer names."
            (let ((name (buffer-name)))
              (unless (string-suffix-p "/" name)
                (rename-buffer (concat name "/") t)))))

(require 'project)
(add-hook 'kill-emacs-hook
          (lambda ()
            "Clear project.el history upon exiting Emacs."
            (setq project--list nil)
            (project--write-project-list)))

(defvar my/manual-projects '()
  "List of manually added project directories.")

(require 'savehist)
(add-to-list 'savehist-additional-variables 'my/manual-projects)
(savehist-mode 1)

(defun my/project-try-manual (dir)
  (when-let* ((root (seq-find (lambda (p)
                                (string-prefix-p p (expand-file-name dir)))
                              my/manual-projects)))
    (cons 'manual root)))

(cl-defmethod project-root ((project (head manual)))
  (cdr project))

(add-hook 'project-find-functions #'my/project-try-manual)

(defun my/project-add (dir)
  (interactive "DAdd project directory: ")
  (let ((dir (file-name-as-directory (expand-file-name dir))))
    (add-to-list 'my/manual-projects dir)
    (project-remember-project (cons 'manual dir))))

(keymap-global-set "C-x p A" #'my/project-add)

;; For use-package
(provide 'my-misc)
