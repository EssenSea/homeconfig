;;; paper-skimming.el --- table-based paper skimming -*- lexical-binding: t; -*-
(require 'table-utils)

(defun paper-skimming--get-journal-paper-in-current-buffer (year-month)
  (let ((results '()) title-doi abstract)
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward (format "** %s" year-month) nil t)
        (outline-next-heading)
        (setq title-doi (format "%s\n\n%s" (org-get-heading t t t t) (org-entry-get nil "doi")))
        (setq abstract (table-utils--get-content-from-drawer "AbstractCH"))
        (push `(:title ,title-doi :abstract ,abstract) results)
        (while (org-goto-sibling)
          (setq title-doi (format "%s\n\n%s" (org-get-heading t t t t) (org-entry-get nil "doi")))
          (setq abstract (table-utils--get-content-from-drawer "AbstractCH"))
          (push `(:title ,title-doi :abstract ,abstract) results))))
    (reverse results)))

;;;###autoload
(defun paper-skimming-insert-dblock ()
  (interactive)
  (let (year-month-list)
    (save-excursion
      (while (re-search-forward "\\*\\* \\([0-9]\\{4\\}-[0-9]\\{2\\}\\)" nil t)
        (unless (org-entry-get nil "processed")
          (push (match-string 1) year-month-list)
          (org-entry-put nil "processed" "t"))))
    (org-create-dblock (list :name "paper-skimming"
                             :year-month (completing-read "Select year-month: " (sort year-month-list #'string>))))
    (org-update-dblock)))


(defun org-dblock-write:paper-skimming (params)
  (let* ((year-month (plist-get params :year-month))
         (paper-list (paper-skimming--get-journal-paper-in-current-buffer year-month))
         (title-width 24)
         (abstract-width 52)
         (titles (table-utils--get-string-from-records
                   paper-list :title title-width))
         (abstracts (table-utils--get-string-list-from-records
                     paper-list :abstract abstract-width t))
         (table-items (table-utils--generate-table
                       (list "title" "abstract")
                       (list titles abstracts)
                       (list title-width abstract-width))))
    (insert (mapconcat 'identity table-items "\n"))))

(defun paper-skimming-delete-paper ()
  (interactive)
  (table-utils--delete-cell-horizontally-at-point))

(defun paper-skimming-open-paper ()
  (interactive)
  (let ((doi (car (last
                   (string-split
                    (table-utils--get-left-first-cell-content-at-point) " ")))))
    (browse-url (format "https://doi.org/%s" doi))))


(defun paper-skimming-goto-cell-below ()
  (interactive)
  (while (not (or (= (char-after (point)) (string-to-char table-utils--cell-split-hline))
                  (= (char-after (point)) (string-to-char table-utils--cell-split-mid-separator))))
    (call-interactively #'next-line))
  (call-interactively #'next-line))

;;;###autoload
(define-minor-mode paper-skimming-mode
  "Provide keymap for paper skimming."
  :global nil
  :init-value nil
  :keymap (list (cons "\C-c\C-c" #'paper-skimming-delete-paper)
                (cons "\C-c\C-o" #'paper-skimming-open-paper)
                (cons "\C-c\C-n" #'paper-skimming-goto-cell-below)))

;;;###autoload
(defun paper-skimming-keep-only-doi-lines ()
  "Extract DOI numbers from lines containing '<a href=\"https://doi.org/...\">'.
Remove lines without DOI links and only keep the DOI numbers for matching lines."
  (interactive)
  (let (source regex doi-list)
    (setq source (completing-read "Type of Source Code: " '("Informs" "AER")))
    (cond
     ((string= source "Informs") (setq regex "<a href=\"https://doi\\.org/\\([^\"]+\\)\">"))
     ((string= source "AER") (setq regex "/articles\\?id=\\([^\"]+\\)\">")))

    (goto-char (point-min))
    (while (re-search-forward regex nil t)
      (push (match-string 1) doi-list))
    (delete-region (point-min) (point-max))
    (mapcar (lambda (x) (insert x "\n")) (nreverse doi-list))))

(provide 'paper-skimming)
