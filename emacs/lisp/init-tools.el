;;; init-tools.el --- Daily tools: which-key, window switching, undo, project, Git -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

;; =====================================================================
;; Utils for basic manipulate
;; =====================================================================

;; for which-key
(define-key help-map (kbd "C-h") nil)
;; instructed notes for striking keys
(use-package which-key
  :ensure which-key-posframe
  :init
  (which-key-mode)
  (which-key-posframe-mode)
  :config
  (setq which-key-posframe-border-width 6)
  ;; (setq which-key-popup-type 'side-window
        ;; which-key-side-window-location 'bottom)
  )

;; manipulate windows
;; (use-package ace-window
;;   :ensure t
;;   :bind (("C-x o" . 'ace-window))
;;   )
(use-package switchy-window
  :ensure t
  :custom (switchy-window-delay 1.5) ;; That's the default value.
  :bind
  (:map switchy-window-minor-mode-map
        ("<remap> <other-window>" . switchy-window)
        )
  :init
  (switchy-window-minor-mode)
  )

;; manupulate chars which are around cursor
(use-package avy
  :ensure t
  :bind (("M-j" . avy-goto-char-timer))
  )

;;undo-redo
(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo)
  )

(use-package undo-fu
  :ensure t
  :bind
  (("C-z" . undo-fu-only-undo)
   ("C-S-z" . undo-fu-only-redo)))

(use-package undo-fu-session
  :ensure t
  :init
  (undo-fu-session-global-mode))


;; DOCS
;; (use-package devdocs
;;   :ensure t)

(use-package project
  :init
  (setq project-vc-ignores
        '("node_modules" ".git" "dist" "build"))
  )
;;project management
;; (use-package projectile
;;   :ensure t
;;   :bind (("C-c p" . projectile-command-map))
;;   :config
;;   (setq projectile-mode-line "Projectile")
;;   (setq projectile-track-known-projects-automatically t))

;; Git co-opperation
;; use vc for version control?
(use-package magit
  :ensure t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :custom
  (magit-diff-refine-hunk 'all)          ; diff 中自动精化 hunk 高亮
  (magit-diff-visit-prefer-worktree t)   ; 打开 diff 中文件时优先工作区内容
  :config
  ;; 在非 macOS / 终端以外系统也提供 M-F12 打开任意已登记仓库
  ;; (global-set-key [(meta f12)] #'magit-status)
  (setq magit-clone-default-directory "/home/moonsea/SrcRepo/")
  )

(use-package vlf
  :ensure t
  :demand t
  :config
  (custom-set-variables '(large-file-warning-threshold (expt 2 22 )))
  (custom-set-variables '(vlf-application 'dont-ask))
  )

;; =====================================================================

(provide 'init-tools)
;;; init-tools.el ends here
