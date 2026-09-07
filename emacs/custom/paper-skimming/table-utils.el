;;; table-utils.el --- table display -*- lexical-binding: t; -*-
(require 'cl-lib)

(defvar table-utils--cell-split-hline "-")
(defvar table-utils--cell-split-mid-separator "+")
(defvar table-utils--cell-split-left-separator "+")
(defvar table-utils--cell-split-right-separator "+")

(defvar table-utils--cell-top-left-separator "+")
(defvar table-utils--cell-top-mid-separator "+")
(defvar table-utils--cell-top-right-separator "+")

(defvar table-utils--cell-bottom-left-separator "+")
(defvar table-utils--cell-bottom-mid-separator "+")
(defvar table-utils--cell-bottom-right-separator "+")

(defvar table-utils--cell-separator "|")
(defvar table-utils--cell-bullet "-")

(defun table-utils--fill-string-split (string width &optional no-bullet)
  "Convert single line string to multi-line filled content.
Output is a list of strings. Each string is corresponding line.

Param:
    string              : input string without bullet symbol
    width               : width of each line
    no-bullet (optional): whether append bullet symbol in the first line

Return:
    List of string
"
  (when (not string)
    (setq string ""
          no-bullet t))
  (with-temp-buffer
    (let* ((padding-size (1+ (length table-utils--cell-bullet)))
           (fill-column (- width padding-size)))
      (when no-bullet
        (setq fill-column width))
      (insert string)
      ;; fill content with specific column width
      (fill-region (point-min) (point-max))
      (unless no-bullet
        (goto-char (point-min))
        (insert (concat table-utils--cell-bullet " "))
        (forward-line 1)
        (while (not (eobp))
          (insert (make-string padding-size ? ))
          (forward-line 1)))
      ;; pad space in the right when necessary
      (mapcar (lambda (x)
                (format (concat "%-" (number-to-string width) "s") x))
              (split-string (buffer-substring (point-min)
                                              (point-max))
                            "\n")))))

(defun table-utils--get-string-list-from-record (record keyword width &optional no-bullet use-hline)
  "Transform the list of strings in record to multi-line string format.

Param:
    record : plist, each element has no bullet symbol
    keyword: the name of the list in the plist
    width  : width of each line

Return:
    List of string, if input list is empty,
        return one element list containing space.
"
  (let ((string-list (plist-get record keyword)))
    (if (> (length string-list) 0)
        (if use-hline
            (butlast
             (apply #'append
                    (mapcar (lambda (item)
                              (table-utils--fill-string-split (concat item "\n") width no-bullet))
                            string-list)))
          (apply #'append
                 (mapcar (lambda (item)
                           (table-utils--fill-string-split item width no-bullet))
                         string-list)))
      (list (make-string width ?\ )))))

(defun table-utils--get-string-list-from-records (records keyword width &optional no-bullet use-hline)
  "Each record has a list, and all strings in the list
will be formatted as multi-line.

Param:
    records: list of plists, each plist contains
               a list of strings without bullet symbol
    keyword: the name of the list in the plist
    width  : width of each line

Return:
    List of string list, each list corresponds to one record.
"
  (mapcar (lambda (record)
            (table-utils--get-string-list-from-record record keyword width no-bullet use-hline))
          records))

(defun table-utils--get-string-from-records (records keyword &optional width)
  "For each record, get string by keyword.

Param:
    records         : list of plists, each plist contains a string
    keyword         : the name of the string in the plist
    width (optional): max width of each line

Return:
    List of string list, each list corresponds to one record.
"
  (if width
      (mapcar (lambda (record)
                (table-utils--fill-string-split
                 (plist-get record keyword) width t))
              records)
    (mapcar (lambda (record)
              (list (plist-get record keyword)))
            records)))

(defun table-utils--generate-table (head-list content-list width-list)
  "Generate table head and body, where body is given by
formating CONTENT-LIST according to WIDTH-LIST.

Params:
    HEAD-LIST   : a list of head strings, omit head line when nil
    CONTENT-LIST: a list of columns, each column is a list of cells,
                  and each cell is a list of strings.
    WIDTH-LIST  : the width for space-padding each column's short cells.

Return:
    list of strings, each element is a line of the table.
"
  (let* ((length-cell (length (car content-list)))
         (top-line
          (concat
           table-utils--cell-top-left-separator
           (mapconcat #'identity
                      (mapcar
                       (lambda (width)
                         (make-string
                          (+ width 2)
                          (string-to-char
                           table-utils--cell-split-hline)))
                       width-list)
                      table-utils--cell-top-mid-separator)
           table-utils--cell-top-right-separator))
         (bottom-line
          (concat
           table-utils--cell-bottom-left-separator
           (mapconcat #'identity
                      (mapcar
                       (lambda (width)
                         (make-string
                          (+ width 2)
                          (string-to-char
                           table-utils--cell-split-hline)))
                       width-list)
                      table-utils--cell-bottom-mid-separator)
           table-utils--cell-bottom-right-separator))
         (split-line
          (concat
           table-utils--cell-split-left-separator
           (mapconcat #'identity
                      (mapcar
                       (lambda (width)
                         (make-string
                          (+ width 2)
                          (string-to-char
                           table-utils--cell-split-hline)))
                       width-list)
                      table-utils--cell-split-mid-separator)
           table-utils--cell-split-right-separator))
         (result '()) head-line)
    (when head-list
      (setq head-line
            (concat
             table-utils--cell-separator
             (mapconcat #'identity
                        (cl-mapcar
                         (lambda (head width)
                           (format (concat " %-" (number-to-string width) "s ") head))
                         head-list width-list)
                        table-utils--cell-separator)
             table-utils--cell-separator)))
    (dotimes (i length-cell)
      ;; Extract the i-th row of cells across all columns
      (let ((cell-lists
             (mapcar (lambda (col) (nth i col))
                     content-list)))
        ;; Determine max length for this set of sub-lists
        (let ((max-len (apply #'max (mapcar #'length cell-lists))))
          ;; Augment shorter sub-lists
          (setq cell-lists
                ;; sublist consists lines of strings in a cell
                (cl-mapcar (lambda (sublist width)
                             (let ((len (length sublist)))
                               (if (< len max-len)
                                   (append sublist
                                           (make-list
                                            (- max-len len)
                                            (make-string width ? )))
                                 sublist)))
                           cell-lists width-list))
          ;; Append a separate line before each cell block
          (push split-line result)
          ;; Now build each line for this i-th cell
          (dotimes (j max-len)
            (push
             (concat
              table-utils--cell-separator
              (mapconcat
               #'identity
               (mapcar
                (lambda (col)
                  (concat " " (nth j col) " "))
                cell-lists)
               table-utils--cell-separator)
              table-utils--cell-separator)
             result)))))
    (if head-line
        (append
         (list top-line head-line)
         (nreverse result)
         (list bottom-line))
      (append
       (list top-line)
       (cdr (nreverse result))
       (list bottom-line)))))

(defun table-utils--get-content-from-drawer (drawer-name)
  "Start from current point to the next heading, find the first ocurrence of
the drawer, extract the content as a list of strings, where each element is
a line without leading bullet symbol if any."
  (let (end drawer-beg drawer-end content-list)
    (setq end (save-excursion (outline-next-heading)))
    (when (re-search-forward (format ":%s:" drawer-name) end t)
      (forward-line)
      (setq drawer-beg (point))
      (when (re-search-forward ":END:" end t)
        (forward-line -1)
        (end-of-line)
        (setq drawer-end (point))))
    (if (and drawer-beg drawer-end)
        (setq content-list
              (seq-filter
               ;; collect all nonemtpy lines
               (lambda (x) (not (string-match-p "^\\s-*$" x)))
               (mapcar (lambda (x)
                         ;; remove bullet symbol
                         (replace-regexp-in-string
                          "^\\(- \\|\\+ \\)" "" x))
                       (split-string
                        (buffer-substring-no-properties drawer-beg drawer-end)
                        "\n"))))
      (setq content-list '()))))

(defun table-utils--get-child-action-headlines ()
  "Get all direct child todo headlines of the current headline in an Org buffer."
  (let (headline-level child-headlines todo-keyword)
    (save-excursion
      (org-back-to-heading t)
      (setq headline-level (org-current-level))
      (outline-next-heading)
      (when (= (org-current-level) (+ 1 headline-level))
        (setq child-headlines '())
        (setq todo-keyword (nth 2 (org-heading-components)))
        (when (not (null todo-keyword))
          (push (org-get-heading t t t t) child-headlines))
        (while (org-goto-sibling)
          (setq todo-keyword (nth 2 (org-heading-components)))
          (when (not (null todo-keyword))
            (push (org-get-heading t t t t) child-headlines))))
      child-headlines)))

(defun table-utils--get-left-first-cell-content-at-point ()
  (let ((content ""))
    (save-excursion
      (beginning-of-line)
      (evil-forward-char)
      (while (not (= (char-after (point)) (string-to-char table-utils--cell-split-hline)))
        (evil-previous-line 1))
      (evil-next-line 1)
      (while (not (= (char-after (point)) (string-to-char table-utils--cell-split-hline)))
        (set-mark (point))
        (while (not (= (char-after (point)) (string-to-char table-utils--cell-separator)))
          (evil-forward-word-end 1))
        (evil-backward-char)
        (setq content (concat content (buffer-substring-no-properties (mark) (point))))
        (goto-char (mark))
        (evil-next-line 1))
      (deactivate-mark)
      (string-trim
       (replace-regexp-in-string "[ \t]+" " " content)))))

(defun table-utils--delete-cell-horizontally-at-point ()
  (beginning-of-line)
  (evil-forward-char)

  (while (not (= (char-after (point)) (string-to-char table-utils--cell-split-hline)))
    (evil-previous-line 1))
  (evil-next-line 1)

  (while (not (= (char-after (point)) (string-to-char table-utils--cell-split-hline)))
    (delete-region (line-beginning-position) (line-beginning-position 2))
    (evil-forward-char))
  (delete-region (line-beginning-position) (line-beginning-position 2))
  (evil-forward-char))


(provide 'table-utils)
