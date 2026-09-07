;;; init-files.el --- File management: Dired and PDF handling -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

;; =====================================================================
;; mime-types for mutimedia files
;; =====================================================================
;; Files manipulations
;; (setq auto-mode-alist
;;         (rassq-delete-all 'doc-view-mode-maybe
;;                           (rassq-delete-all 'doc-view-mode auto-mode-alist)))
(setq mailcap-user-mime-data
      (append mailcap-user-mime-data
              '(((type . "application/pdf")
                 (viewer . "sioyek")
                 )))
      )

(require 'dired)
(defun open-pdf-externally-with-sioyek (&optional prefix)
  "在 Dired 中, 对 PDF 文件(也许是PREFIX)用外部程序打开, 其他文件正常处理."
  (interactive "P")
  (let ((file (dired-get-file-for-visit)))
    (if (and file (string= (file-name-extension file) "pdf"))
        (call-process "sioyek" nil 0 nil file)  ; 可替换为 zathura、evince 等
      (dired-find-file))))
;; (define-key dired-mode-map (kbd "RET") #'open-pdf-externally-with-sioyek)

(use-package dired
  :ensure nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode)
  (dired-mode . auto-revert-mode)
  :config
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq dired-listing-switches "-alh")
  (define-key dired-mode-map (kbd "RET")
              #'open-pdf-externally-with-sioyek)
  )


;; =====================================================================

(provide 'init-files)
;;; init-files.el ends here
