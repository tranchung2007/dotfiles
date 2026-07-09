;;; -*- lexical-binding: t; -*-

(keymap-global-unset "C-x p") ;; Fck project.el
(keymap-global-unset "C-x C-z")
(keymap-global-unset "C-x C-d") ;; We have C-x C-f, you know
(keymap-global-unset "C-z")
(keymap-global-set "C-x p g" #'grep)
(keymap-global-set "C-x p f" #'my/fd-find-file)
(keymap-global-set "M-u" #'upcase-dwim)
(keymap-global-set "M-l" #'downcase-dwim)
(keymap-global-set "M-c" #'capitalize-dwim)

;; This is totally Ai slops, idk wtf is going here
(defun my/fido-highlight-directories (orig string table pred &rest rest) (let ((res (apply orig string table pred rest))) (if (not (minibufferp)) res (when (eq (completion-metadata-get (completion-metadata string table pred) 'category) 'file) (let ((tail res)) (while (consp tail) (let ((item (car tail))) (when (and (stringp item) (string-suffix-p "/" item)) (let ((c (copy-sequence item))) (add-face-text-property 0 (length c) 'dired-directory t c) (setcar tail c)))) (setq tail (cdr tail))))) res)))
(advice-add #'completion-all-completions :around #'my/fido-highlight-directories)
(defun my/minibuffer-update-path-overlay (ov) (let ((beg (minibuffer-prompt-end))) (save-excursion (goto-char (point-max)) (if (search-backward "/" beg t) (move-overlay ov beg (1+ (point))) (move-overlay ov beg beg)))))
(defun my/minibuffer-setup-path-highlight () (when (eq (completion-metadata-get (completion-metadata (minibuffer-contents) minibuffer-completion-table minibuffer-completion-predicate) 'category) 'file) (let* ((ov (make-overlay 1 1 nil t t)) (update (lambda (&rest _) (my/minibuffer-update-path-overlay ov)))) (overlay-put ov 'face 'dired-directory) (overlay-put ov 'priority 100) (add-hook 'after-change-functions update nil t) (add-hook 'minibuffer-exit-hook (lambda () (remove-hook 'after-change-functions update t) (delete-overlay ov)) nil t) (funcall update))))
(add-hook 'minibuffer-setup-hook #'my/minibuffer-setup-path-highlight)

;; Add / to dired buffer name
(add-hook 'dired-mode-hook
          (lambda ()
            (unless (string-suffix-p "/" (buffer-name))
              (rename-buffer (concat (buffer-name) "/") t))))

(defun my/smart-electric-indent (_)
  (let ((ppss (syntax-ppss)))
    (when (or (nth 3 ppss)
              (nth 4 ppss))
      'no-indent)))
(add-hook 'electric-indent-functions #'my/smart-electric-indent)

(defun my/fd-find-file ()
  "Find a file beneath `default-directory' using fd."
  (interactive)
  (let ((choice
         (completing-read
          "Find file: "
          (process-lines "fd" "--type" "f" "--hidden" "--exclude" ".git" "--color=never" "--strip-cwd-prefix")
          nil t)))
    (unless (string-empty-p choice)
      (find-file (expand-file-name choice default-directory)))))

(provide 'my-misc)
