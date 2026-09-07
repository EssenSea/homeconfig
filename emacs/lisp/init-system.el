;;; init-system.el --- System administration and global keymaps -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

;; =====================================================================
;; System admin
;; =====================================================================
(use-package pinentry
  :ensure t
  :init
  (pinentry-start)
  )

(use-package woman
  :init
  (setq woman-emulation 'troff)
  :config
  (setq woman-manpath (ignore-errors (split-string (getenv "MANPATH") ":" t)))
  :custom
  (custom-set-variables
   '(warning-suppress-log-types
     '((defvaralias losing-value woman-topic-history))))
  )

(use-package disk-usage
  :ensure t
  :demand t
  )

(use-package daemons
  :ensure t
  :demand t
  :config
  (add-hook 'daemons-mode-hook eldoc-mode)
  )

(use-package logview
  :ensure t
  :demand t)

(use-package eselect-news
  :ensure t
  :demand t)

(use-package portage-modes
  :ensure t
  :demand t
)

;; =====================================================================
;; Key maps
;; =====================================================================

;; Org-mode relative
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c c") 'org-capture)

(global-set-key (kbd "<f10>") 'tmm-menubar)
(global-set-key (kbd "C-x C-o") 'window-swap-states)
;; Outline-minor-mode
;; (define-prefix-command 'cm-map nil "Outline-")
;; ;; hidden
;; (define-key cm-map "q" 'outline-hide-sublevels)   ; 仅保留顶级标题
;; (define-key cm-map "t" 'outline-hide-body)        ; 隐藏所有正文
;; (define-key cm-map "o" 'outline-hide-other)       ; 隐藏其他分支
;; (define-key cm-map "c" 'outline-hide-entry)       ; 隐藏当前条目正文
;; (define-key cm-map "d" 'outline-hide-subtree)     ; 隐藏当前子树
;; ;; reveal
;; (define-key cm-map "a" 'outline-show-all)         ; 展开全部
;; (define-key cm-map "e" 'outline-show-entry)       ; 显示当前条目正文
;; (define-key cm-map "k" 'outline-show-branches)    ; 显示所有子标题
;; ;; move
;; (define-key cm-map "u" 'outline-up-heading)               ; 向上一级
;; (define-key cm-map "n" 'outline-next-visible-heading)     ; 下一个标题
;; (global-set-key (kbd "C-c o") cm-map)  ; 绑定前缀

;; =====================================================================

(provide 'init-system)
;;; init-system.el ends here
