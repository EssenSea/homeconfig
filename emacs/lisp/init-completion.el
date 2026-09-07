;;; init-completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

;; =====================================================================
;; Vertico + orderless + consult + marginlia for minibuffer supplementary
;; =====================================================================
(use-package savehist
  :init
  (savehist-mode))

;; (use-package emacs
  ;; :custom
(setq context-menu-mode t)
(setq enable-recursive-minibuffers nil)
(setq read-extended-command-predicate #'command-completion-default-include-p)
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))

;; vertico: UI manipulation for minibuffer
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :bind
  (:map
   vertico-map
   ;; ("TAB" . minibuffer-complete) ;; the traditional emacs complete style
   ("TAB" . vertico-next)
   ("<backtab>" . vertico-previous)
   ("M-TAB" . vertico-insert)
   )
  :custom
  (vertico-scroll-margin 0)
  (vertico-cycle t)                   ; 允许循环选择（到末尾再按会回到开头）
  (vertico-resize t)                  ; 自动调整窗口大小以显示完整候选项
  (vertico-count 15)                  ; 默认显示 10 个候选项
  )
  

;; (icomplete-vertical-mode t)

;; (use-package mct
;;   :ensure t
;;   :init
;;   (mct-mode 1)
;;   )
;; Orderless: Completion backend

(use-package orderless
  :ensure t
  :demand t
  :custom
  (completion-styles
   '(orderless basic partial-completion flex)) ; 设置补全风格为首选 orderless
  (completion-category-defaults nil)       ; 避免其他类别覆盖
  (completion-category-overrides
   '((file
      (styles basic partial-completion)))) ; 文件路径保留部分匹配
  (orderless-component-separator
   #'orderless-escapable-split-on-space)
  )
(use-package prescient
  :ensure t
  :demand t
  :custom
  (prescient-filter-method nil)
  (prescient-sort-full-matches-first t)
  :config
  (prescient-persist-mode t))

;; Marginalia sidenotes in minibuffer
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
	          ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(recentf-mode 1)
(setq recentf-max-menu-items 10
      recentf-max-saved-items 100)

;; Consult: Supplimentary for search
(use-package consult
  :ensure t
  :bind
  (("C-s" . consult-line)                     ; 搜索当前缓冲区
   ("C-c C-s" . consult-ripgrep)              ; 项目内搜索
   ("C-x b" . consult-buffer)                 ; 切换缓冲区（带文件、bookmark等）
   ("C-c C-p" . consult-project-buffer)       ; 项目内文件切换
   ("C-c C-r" . consult-recent-file)          ; 最近文件
   ("C-M-y" . consult-yank-pop)                 ; 增强的剪贴板历史
   ("C-h C-m" . consult-man)
   ;; ("C-x C-f" . consult-find)                 ; 查找文件（类似 find）
   ;; ("C-c C-g" . consult-grep)                 ; 增强的 grep
   ("C-h !" . consult-flymake)                ; 查看 flymake 错误
   :map isearch-mode-map
   ("C-o" . consult-isearch-history)          ; 在 isearch 中查看历史
   :map minibuffer-local-map
   ("C-r" . consult-history)                  ; 在 minibuffer 中调用历史搜索
   ("C-s" . consult-history))
  :config
  ;; 启用自动预览（可选，在候选间移动时立即显示效果）
  ;; (setq consult-preview-key (kbd "M-."))
  (setq consult-preview-key nil)
  ;; 让 consult 使用 orderless 风格
  (setq
   consult-async-default-split-function
   #'consult-async-split-style-default)
  ;; Integrated with perspective
  (consult-customize consult-source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  )

;; Embark: manipulate menus
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)                      ; 全局操作菜单
   ("C-," . embark-dwim)                     ; 智能操作
   ("C-h B" . embark-bindings))              ; 查看所有 embark 操作
  ;; :init
  ;; (setq prefix-help-command #'embark-prefix-help-command) ; 让 C-h 能显示 embark 操作
  )

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  )

(use-package vertico-posframe
  :ensure t
  :after vertico
  :config
  ;; (add-to-list 'vertico-multiform-categories '(embark-keybinding grid))
  (setq vertico-posframe-border-width 6)
  (vertico-posframe-mode 1)
  ;; (vertico-multiform-mode 1)
  ;; (setq vertico-multiform-commands
        ;; '((vertico-posframe-fallback-mode . vertico-buffer-mode)))
  (setq vertico-posframe-parameters
        '((left-fringe . 10) (right-fringe . 10)))
  )

(use-package wgrep
  :ensure t
  :bind
  (:map grep-mode-map
        ("C-c C-e" . wgrep-change-to-wgrep-mode))
)



; =====================================================================
;; Completion inside buffers: Corfu + Cape + Tempel
;; =====================================================================

;;  Corfu UI
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode 1)                ; 全局启用
  :custom
  (corfu-cycle t)                      ; 循环选择
  (corfu-auto t)                       ; 自动弹出补全
  (corfu-auto-delay 0.1)               ; 延迟 0.1 秒弹出
  (corfu-auto-prefix 2)                ; 输入 2 个字符后触发
  (corfu-popupinfo-mode t)             ; 启用文档弹窗（可选）
  (corfu-popupinfo-delay 0.5)          ; 文档延迟 0.5 秒显示
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)           ; TAB 向下选择
        ("S-TAB" . corfu-previous)     ; S-TAB 向上选择
        ("C-j" . corfu-insert)         ; 确认并退出
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        )
  )

;; Cape for completions' backend
(use-package cape
  :ensure t
  :demand t
  :config
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-abbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-elisp-symbol)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  ;; (add-hook 'completion-at-point-functions #'tempel-expand)
  (add-hook 'completion-at-point-functions #'tempel-complete)
  )

;; pretiffy UI supplied by corfu
(use-package kind-icon
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))
;; (use-package nerd-icons-corfu
;;   :ensure t
;;   :after corfu
;;   :demand t
;;   :config
;;   (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;; Tempel for snippets
(use-package tempel
  :ensure t
  :demand t
  :bind (("M-+" . tempel-complete)   ;; 手动触发模板补全
         ("M-*" . tempel-insert)     ;; 通过选择列表插入模板
         ;; ("C-M-i" . tempel-expand)
         )
  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.  `tempel-expand'
    ;; only triggers on exact matches. We add `tempel-expand' *before* the main
    ;; programming mode Capf, such that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-complete completion-at-point-functions))

    ;; Alternatively use `tempel-complete' if you want to see all matches.  Use
    ;; a trigger prefix character in order to prevent Tempel from triggering
    ;; unexpectly.
    ;; (setq-local corfu-auto-trigger "/"
    ;;             completion-at-point-functions
    ;;             (cons (cape-capf-trigger #'tempel-complete ?/)
    ;;                   completion-at-point-functions))
    )

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  :config

  (setq tempel-path
        (expand-file-name
         ;; "elpa/tempel-collection-20260227.1133/templates/*/*.eld"
         "templates/*.eld"
         user-emacs-directory))
  )

(use-package tempel-collection
  :ensure t
  :demand t
  :after tempel)

(use-package  yasnippet
  :ensure t
  :demand t
  :hook
  (prog-mode . yas-minor-mode )
  :bind
  ;; (:map yas-minor-mode-map ("M-C-i" . yas-expand))
  :config
  (yas-reload-all)
  ;; add company-yasnippet to company-backends
  ;; (defun company-mode/backend-with-yas (backend)
  ;;   (if (and (listp backend) (member 'company-yasnippet backend))
  ;;   backend
  ;;     (append (if (consp backend) backend (list backend))
  ;;             '(:with company-yasnippet))))
  ;; (setq company-backends (mapcar #'company-mode/backend-with-yas
  ;;   			                 company-backends))
  ;; unbind <TAB> completion
  (define-key yas-minor-mode-map [(tab)]        nil)
  (define-key yas-minor-mode-map (kbd "TAB")    nil)
  (define-key yas-minor-mode-map (kbd "<tab>")  nil)
  )

(use-package yasnippet-snippets
  :after yasnippet
  :ensure t
  :demand t)
(use-package yasnippet-capf
  :ensure t
  :custom
  (setq completion-at-point-functions
        (cons #'yasnippet-capf
              completion-at-point-functions))
  (debug)
  )

;; =====================================================================

(provide 'init-completion)
;;; init-completion.el ends here
