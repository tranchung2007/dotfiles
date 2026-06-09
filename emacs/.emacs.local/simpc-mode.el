;; -*- lexical-binding: t; -*-
(require 'subr-x)

;;; Customization

(defgroup simpc nil
  "Customization group for `simpc-mode`."
  :group 'languages)

(defcustom simpc-indent-width 4
  "Number of spaces for each indentation step."
  :type 'integer
  :group 'simpc)

(defcustom simpc-use-tabs nil
  "Whether to use tabs for indentation."
  :type 'boolean
  :group 'simpc)

;;; Syntax and Font Locking

(defvar simpc-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; C/C++ style comments
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    ;; Preprocessor
    (modify-syntax-entry ?# "." table)
    ;; Chars are the same as strings
    (modify-syntax-entry ?' "\"" table)
    ;; Treat <> as punctuation (needed to highlight C++ keywords properly)
    (modify-syntax-entry ?< "." table)
    (modify-syntax-entry ?> "." table)
    (modify-syntax-entry ?& "." table)
    (modify-syntax-entry ?% "." table)
    table))

(defun simpc-types ()
  '("char" "int" "long" "short" "void" "bool" "float" "double" "signed" "unsigned"
    "char16_t" "char32_t" "char8_t"
    "int8_t" "uint8_t" "int16_t" "uint16_t" "int32_t" "uint32_t" "int64_t" "uint64_t"
    "uintptr_t" "size_t" "ptrdiff_t" "va_list"))

(defun simpc-keywords ()
  '("auto" "break" "case" "const" "continue" "default" "do"
    "else" "enum" "extern" "for" "goto" "if" "register"
    "return" "sizeof" "static" "struct" "switch" "typedef"
    "union" "volatile" "while" "alignas" "alignof" "and"
    "and_eq" "asm" "atomic_cancel" "atomic_commit" "atomic_noexcept" "bitand"
    "bitor" "catch" "class" "co_await"
    "co_return" "co_yield" "compl" "concept" "const_cast" "consteval" "constexpr"
    "constinit" "decltype" "delete" "dynamic_cast" "explicit" "export" "false"
    "friend" "inline" "mutable" "namespace" "new" "noexcept" "not" "not_eq"
    "nullptr" "operator" "or" "or_eq" "private" "protected" "public" "reflexpr"
    "reinterpret_cast" "requires" "static_assert" "static_cast" "synchronized"
    "template" "this" "thread_local" "throw" "true" "try" "typeid" "typename"
    "using" "virtual" "wchar_t" "xor" "xor_eq"))

;; font-lock-defaults expects a variable or a quoted list, not a function call.
;; Store keywords in a variable so font-lock can properly handle them.
(defvar simpc-font-lock-keywords
  (list
   '("# *\\(warn\\|error\\)" . font-lock-warning-face)
   '("# *[#a-zA-Z0-9_]+" . font-lock-preprocessor-face)
   '("# *include\\(?:_next\\)?\\s-+\\(\\(<\\|\"\\).*\\(>\\|\"\\)\\)" . (1 font-lock-string-face))
   '("\\(?:enum\\|struct\\|class\\|namespace\\)\\s-+\\([a-zA-Z0-9_]+\\)" . (1 font-lock-type-face))))

;; Keywords and types must be added after the variable is defined since we
;; call helper functions here. We append them in the mode setup instead.

;;; Indentation Engine

(defun simpc--previous-non-empty-line ()
  "Return nil when no previous non-empty line exists, or (line . indentation)."
  (save-excursion
    (move-beginning-of-line nil)
    (if (bobp)
        nil
      (forward-line -1)
      (while (and (not (bobp))
                  (string-empty-p
                   (string-trim-right
                    (thing-at-point 'line t))))
        (forward-line -1))
      (if (string-empty-p
           (string-trim-right
            (thing-at-point 'line t)))
          nil
        (cons (thing-at-point 'line t)
              (current-indentation))))))

(defun simpc--open-brace-indent (paren-pos indent-len)
  "Return the correct indentation for code inside the '{' at PAREN-POS.
For namespace blocks: no extra indent (returns opener's indentation).
For case/default blocks (e.g. `case X: {`): case-label-indent + INDENT-LEN.
For all other blocks: block-opener's indentation + INDENT-LEN."
  (save-excursion
    (goto-char paren-pos)
    ;; Stay on the same line — skip spaces/tabs only, NOT newlines.
    ;; Skipping newlines would jump to a different line and give the wrong
    ;; current-indentation when the brace is the first token on its line.
    (skip-chars-backward " \t")
    (let ((line (thing-at-point 'line t))
          (true-indent (current-indentation)))
      (cond
       ;; namespace blocks are not indented
       ((string-match-p "^\\s-*namespace\\b" line)
        true-indent)
       ;; case/default with an inline opening brace: `case X: {`
       ;; The body must be one level deeper than the case label itself.
       ((string-match-p "^\\s-*\\(case\\b.*:\\|default\\s-*:\\)" line)
        (+ true-indent indent-len))
       ;; For if/for/while: '{' follows ')'; jump to matching '(' to land on
       ;; the keyword's column rather than the closing-paren's column.
       (t
        (when (eq (char-before) ?\))
          (backward-char)
          (ignore-errors (backward-list)))
        (+ (current-indentation) indent-len))))))

(defun simpc--desired-indentation ()
  "Calculate the desired indentation for the current line."
  (let ((prev (simpc--previous-non-empty-line)))
    (if (not prev)
        0
      (let* ((indent-len simpc-indent-width)
             (cur-line   (string-trim-right (thing-at-point 'line t)))
             (cur-trim   (string-trim-left cur-line))
             (prev-line  (string-trim-right (car prev)))
             (prev-trim  (string-trim-left prev-line))
             (prev-indent (cdr prev))

             ;; syntax-ppss must be called at the first non-space character of
             ;; the current line (or end-of-line for blank lines).  Calling it
             ;; at point (which may be at column 0 before indentation) gives
             ;; the wrong parse state when the line is blank and follows a '{'.
             (ppss      (save-excursion
                          (back-to-indentation)
                          (syntax-ppss)))
             (paren-pos (nth 1 ppss))   ; innermost open delimiter, or nil

             ;; The indentation level that code *inside* the nearest enclosing
             ;; '{' block should sit at.  Only meaningful when paren-pos is a '{'.
             (block-body-indent
              (and paren-pos
                   (eq (char-after paren-pos) ?\{)
                   (simpc--open-brace-indent paren-pos indent-len)))

             ;; For paren/bracket alignment we just indent one step from the
             ;; line that opened the delimiter.
             (paren-body-indent
              (and paren-pos
                   (save-excursion
                     (goto-char paren-pos)
                     (+ (current-indentation) indent-len)))))

        (cond

         ;; ── 0. Preprocessor directives always snap to column 0 ────────────
         ((string-match-p "^\\s-*#" cur-line)
          0)

         ;; ── 1. Closing brace ──────────────────────────────────────────────
         ;; The '}' should align with the line that opened its block.
         ((string-prefix-p "}" cur-trim)
          (if block-body-indent
              ;; block-body-indent is already opener + indent-len, so subtract
              ;; indent-len to get back to the opener's column.
              (max (- block-body-indent indent-len) 0)
            ;; Fallback: one step left of previous indent
            (max (- prev-indent indent-len) 0)))

         ;; ── 2. We are inside a '{' block ──────────────────────────────────
         ((and paren-pos (eq (char-after paren-pos) ?\{))
          (cond

           ;; 2a. switch: case / default labels indent one step inside switch
           ((string-match-p "^\\s-*switch\\s-*(.*)\\s-*{?\\s-*$" prev-line)
            (+ prev-indent indent-len))

           ;; 2b. case/default label itself.
           ;; block-body-indent is the indentation for code inside the nearest
           ;; enclosing '{'.  For a switch block that IS the column where case
           ;; labels should sit — no adjustment needed.
           ((string-match-p "^\\s-*\\(case\\b.*:\\|default\\s-*:\\)" cur-trim)
            block-body-indent)

           ;; 2c. Code after a bare case/default label (no opening brace).
           ;; If the case line already has a '{', the block-body-indent from
           ;; the enclosing '{' handles indentation instead (case 2h).
           ((and (string-match-p "^\\s-*\\(case\\b.*:\\|default\\s-*:\\)" prev-line)
                 (not (string-suffix-p "{" prev-trim)))
            (+ prev-indent indent-len))

           ;; 2d. C++ constructor initializer list continuation
           ;; ": member(val)" or ", member(val)"
           ((string-match-p "^\\s-*[:,]" cur-trim)
            (if (string-match-p "^\\s-*[:,]" prev-trim)
                prev-indent                     ; align with previous init
              (+ prev-indent indent-len)))       ; first item after ')'

           ;; 2e. Opening '{' of an init-list arm
           ((and (string-match-p "^\\s-*[:,]" prev-trim)
                 (string-prefix-p "{" cur-trim))
            (max (- prev-indent indent-len) 0))

           ;; 2f. Goto labels (e.g. `retry:` on its own line).
           ;; Explicitly exclude case/default to avoid false matches.
           ((and (string-match-p "^\\s-*[a-zA-Z0-9_]+\\s-*:\\s-*$" cur-trim)
                 (not (string-match-p "^\\s-*\\(case\\|default\\)\\b" cur-trim)))
            (max (- block-body-indent indent-len) 0))

           ;; 2g. Code right after a goto label
           ((and (string-match-p "^\\s-*[a-zA-Z0-9_]+\\s-*:\\s-*$" prev-trim)
                 (not (string-match-p "^\\s-*\\(case\\|default\\)\\b" prev-trim)))
            (+ prev-indent indent-len))

           ;; 2h. Normal block body — use the pre-computed block-body-indent
           (t block-body-indent)))

         ;; ── 3. We are inside '(' or '[' ───────────────────────────────────
         ((and paren-pos
               (memq (char-after paren-pos) '(?\( ?\[)))
          paren-body-indent)

         ;; ── 4. Not inside any delimiter ───────────────────────────────────
         (t
          (cond

           ;; 4a. C++ template angle-bracket tracking (best-effort)
           ((and (string-suffix-p "<" prev-trim)
                 (string-prefix-p ">" cur-trim))
            prev-indent)
           ((string-suffix-p "<" prev-trim)
            (+ prev-indent indent-len))
           ((string-prefix-p ">" cur-trim)
            (max (- prev-indent indent-len) 0))

           ;; 4b. Previous line ends with '{' — next line is the block body.
           ;; Use prev-indent directly; no point re-navigating since we already
           ;; have the opener's indentation.  Namespace blocks don't add a level.
           ((string-suffix-p "{" prev-trim)
            (if (string-match-p "^\\s-*namespace\\b" prev-line)
                prev-indent
              (+ prev-indent indent-len)))

           ;; 4c. Continuation lines (line ends with operator / comma / backslash)
           ((string-match-p "\\([,=+\\-*/\\|&^]\\|&&\\|||\\|\\\\\\)\\s-*$" prev-trim)
            (+ prev-indent indent-len))

           ;; 4d. Statement ended — return to prev indent
           ((string-match-p "[;}]\\s-*$" prev-trim)
            prev-indent)

           ;; 4e. Default: keep previous indentation
           (t prev-indent))))))))

(defun simpc-indent-line ()
  "Indent the current line as C/C++ code."
  (interactive)
  (unless (bobp)
    (setq-local indent-tabs-mode simpc-use-tabs)
    (let ((desired (simpc--desired-indentation)))
      (if (string-empty-p (string-trim (thing-at-point 'line t)))
          (progn
            (delete-region (line-beginning-position) (line-end-position))
            (indent-to desired))
        (if (<= (current-column) (current-indentation))
            (indent-line-to desired)
          (save-excursion
            (indent-line-to desired)))))))

(define-derived-mode simpc-mode prog-mode "Simple C"
  "Simple major mode for editing C/C++ files."
  :syntax-table simpc-mode-syntax-table
  ;; Build font-lock keywords now that helper functions are available.
  (setq-local font-lock-defaults
              (list (append simpc-font-lock-keywords
                            (list (cons (regexp-opt (simpc-keywords) 'symbols)
                                        'font-lock-keyword-face)
                                  (cons (regexp-opt (simpc-types) 'symbols)
                                        'font-lock-type-face)))))
  (setq-local indent-line-function #'simpc-indent-line)
  (setq-local comment-start "// "))

(provide 'simpc-mode)
;;; simpc-mode.el ends here
