;;; -*- lexical-binding: t; -*-

(keymap-global-unset "C-x p")
(keymap-global-set "C-x p g" #'grep)
(keymap-global-set "C-x p f" #'my/fd-find-file)

(defun my/fido-highlight-directories (orig-fun &rest args)
  "Highlight directories and dired buffers in `fido-mode' completions."
  (let* ((res (apply orig-fun args))
         (category (completion-metadata-get
                    (completion-metadata (car args) (cadr args) (caddr args))
                    'category)))
    (when (memq category '(file buffer))
      (let ((cell res))
        (while (consp cell)
          (let ((s (car cell)))
            (when (and (stringp s)
                       (if (eq category 'file)
                           (string-suffix-p "/" s)
                         (when-let* ((buf (get-buffer s)))
                           (provided-mode-derived-p
                            (buffer-local-value 'major-mode buf)
                            'dired-mode))))
              (setcar cell (propertize s 'face 'dired-directory))))
          (setq cell (cdr cell)))))
    res))
(advice-add 'completion-all-completions :around #'my/fido-highlight-directories)

(defun my/minibuffer-setup-path-highlight ()
  "Highlight the directory portion of the path in the minibuffer."
  (when (eq (completion-metadata-get
             (completion-metadata "" minibuffer-completion-table
                                  minibuffer-completion-predicate)
             'category)
            'file)
    (let ((ov (make-overlay (minibuffer-prompt-end) (minibuffer-prompt-end))))
      (overlay-put ov 'face 'dired-directory)
      (add-hook 'minibuffer-exit-hook (lambda () (delete-overlay ov)) nil t)
      (add-hook 'post-command-hook
                (lambda ()
                  (let* ((beg (minibuffer-prompt-end))
                         (dir (file-name-directory
                               (buffer-substring-no-properties beg (point-max)))))
                    (move-overlay ov beg (if dir (+ beg (length dir)) beg))))
                nil t))))
(add-hook 'minibuffer-setup-hook #'my/minibuffer-setup-path-highlight)

(add-hook 'dired-after-readin-hook
          (lambda ()
            "Ensure Dired buffers end with a trailing slash."
            (let ((name (buffer-name)))
              (unless (string-suffix-p "/" name)
                (rename-buffer (concat name "/") t)))))

(defun my/smart-electric-indent (_char)
  "Inhibit electric indent inside strings or comments."
  (let ((parse-state (syntax-ppss)))
    (if (or (nth 3 parse-state)
            (nth 4 parse-state))
        'no-indent
      nil)))
(add-hook 'electric-indent-functions #'my/smart-electric-indent)

(defun my/fd-find-file ()
  "Find a file using `fd` starting only from the current directory."
  (interactive)
  (let* ((file-list (process-lines-ignore-status
                     "fd" "--type" "f" "--hidden" "--exclude" ".git" "--color=never"))
         (choice (completing-read "Find file: " file-list nil t)))
    (when (and choice (not (string-empty-p choice)))
      (find-file (expand-file-name choice default-directory)))))

(provide 'my-misc)
