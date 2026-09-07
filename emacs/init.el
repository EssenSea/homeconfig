;;; init.el --- Elisp For Initialize Emacs         -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author:  <moonsea@gentoo>
;; Keywords: lisp, extensions, convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This is an personal Emacs initialized file, not comfort for others

;;; Code:

;; =====================================================================
;; performance Check during init process
;; =====================================================================
;; init.el 顶部，package-activate-all 之前
(setq package-quickstart t)
(require 'package)
(setq package-archives '(("gnu"
                          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu"
                          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"
                          . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; (package-initialize)
(package-activate-all)
(require 'use-package)
(setq package-native-compile t)
(setq package-install-upgrade-built-in t)

(require 'package-vc)
(setq package-vc-allow-build-commands t)

(when init-file-debug
  (setq use-package-verbose nil
        use-package-expand-minimally t
        use-package-compute-statistics t
        debug-on-error t))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defconst *spell-check-support-enable* nil)

;; devide customs
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)
(require 'benchmarking)
;; (require 'benchmark-init)
;; =====================================================================
;; Global configurations
;; =====================================================================


(setq calendar-chinese-all-holidays-flag t)

;; Files Backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backups"))
      make-backup-files t   ; backup enable
      auto-save-default t
      )

;; Indent setup
(setq-default fill-column 78          ; columns numbers(width) filling a line
              indent-tabs-mode nil    ; indent with "space" rather than "tab"
              tab-width 4)            ; indent with 4 "space" width

(setq
 ; indent standard with 4 "space"
 standard-indent 4
 ;; del the whole indent
 backward-delete-char-untabify-method 'hungry)

;; default hook with prog-mode
(add-hook 'prog-mode-hook
          (lambda ()
            (display-line-numbers-mode t)
            (hs-minor-mode t)            ; fold
            (show-paren-mode t)          ; highlight paren
            (flymake-mode t)
            ))

(add-hook 'text-mode-hook
          (lambda ()
            (outline-minor-mode t)))

(setq tmm-completion-prompt nil)


;; (outline-minor-mode t)       ; 大纲模式
(global-auto-revert-mode t)  ; 自动刷新 Buffer
(savehist-mode t)            ; 保存历史记录
(electric-pair-mode t)       ; 自动补全括号
(auto-fill-mode t)           ; 启用自动折行
(delete-selection-mode t)    ; 覆盖选中文本

(setq display-time-load-average nil
      display-time-load-average-threshold nil
      display-time-day-and-date t)
(display-time-mode t)
;; 优化超长行处理性能
(global-so-long-mode t)
(setq long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(setopt minibuffer-help-form t)
(use-package helpful
  :ensure t
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ;; Lookup the current symbol at point.  C-c C-d is a common keybinding
   ;; for this in Lisp modes.
   ("C-c C-d" . helpful-at-point)
   ;; By default, C-h F is bound to `Info-goto-emacs-command-node'.  Helpful
   ;; already links to the manual, if a function is referenced there.
   ("C-h F" . helpful-function)))

;; =====================================================================
;; Basic UI Setup
;; =====================================================================

;; Color Themes

(use-package kaolin-themes
  :ensure t
  :demand t)

(use-package circadian
  :ensure t
  :demand t
  :config
  (setq calendar-latitude 34.59
        calendar-longitude 103.50
        circadian-themes '(
                           ;; (:sunrise . modus-operandi-deuteranopia)
                           ;; (:sunrise . dichromacy)
                           ;; (:sunrise . kaolin-light)
                           ;; (:sunrise . kaolin-mono-light)
                           ;; (:sunrise . kaolin-temple)
                           ;; (:sunset . kaolin-mono-dark)
                           ;; (:sunset . kaolin-galaxy)
                           (:sunset . kaolin-bubblegum)
			               ;; (:sunset . modus-vivendi-deuteranopia)
                           ;; (:sunset . modus-vivendi)
                           ;; (:sunset . modus-vivendi-tinted)
                           ;; (:sunset . modus-vivendi-tritanopia)
                           ))
  (circadian-setup))

;; Change Startup Screen Show
(use-package dashboard
  :ensure t
  :demand t
  :config
  (setq dashboard-icon-type 'nerd-icons
        dashboard-set-file-icons t
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-banner-logo-title "Hacking Emacs"
        dashboard-projects-backend 'project-el
        ;; dashboard-startup-banner '(1 2 3 4) ;; 也可以自定义图片
        dashboard-startup-banner '"~/.emacs.d/bannners/emacs.txt"
        dashboard-items '((recents . 5)     ;; 显示多少个最近文件
			              (bookmarks . 3)
			              (projects . 3)
                          (registers . 3))
        ;; dashboard-recentf-show-base nil
        ;; dashboard-recentf-item-format "%s %s"
        ;; dashboard-projects-show-base nil
        ;; dashboard-bookmarks-show-base nil
        )
  (dashboard-setup-startup-hook)
  )

;; Header & mode lines
(use-package doom-modeline
  :demand t
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :init
  (setq doom-modeline-mu4e t
        doom-modeline-persp-icon nil
        doom-modeline-persp-name nil
        doom-modeline-persp-display-default-name nil
        doom-modeline-total-line-number t
        ))

;; Screen Display Supplementary
(global-hl-line-mode t)
(column-number-mode t)
(setq display-line-numbers-type 'relative)
;; (global-display-line-numbers-mode t)

(global-display-fill-column-indicator-mode t)
(add-hook 'text-mode-hook
          (lambda ()
            (set-default default-justification 'full)))
;; (display-fill-column-indicator-mode-set-explicitly)

(use-package olivetti
  :ensure t
  :hook
  ((eww-mode) . olivetti-mode)
  :bind ("C-c w" . olivetti-mode)
  :config
  (setq olivetti-body-width 100
        olivetti-recall-last t))

;; nerd font and icons
(use-package nerd-icons
  :demand t
  :ensure t)

;;different color for different level of parens
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  )

;; Prettifing chars such as Greek Chars
;; (global-prettify-symbols-mode t)

(set-fontset-font
 "fontset-default" nil (font-spec :family "Sarasa Mono Slab SC"))

(set-fontset-font t 'symbol "Noto emoji" nil 'append)

(set-face-font 'default "Sarasa Mono Slab SC-16")

(custom-set-faces
 '(variable-pitch
   ((t (:height 160 :width normal :family "Sarasa Term SC Nerd")))))

(use-package shr
  :init
  (setq shr-use-fonts nil)
  (setq shr-width fill-column)
  (setq shr-fill-text t)
  )


;; (set-face-attribute 'shr-text nil
;; :inherit 'default)


;; (system-taskbar-mode t)
;; (use-package system-taskbar-mode)
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
                 (viewer . "esioyek")
                 )))
      )

(require 'dired)
(defun open-pdf-externally-with-sioyek (&optional prefix)
  "在 Dired 中, 对 PDF 文件(也许是PREFIX)用外部程序打开, 其他文件正常处理."
  (interactive "P")
  (let ((file (dired-get-file-for-visit)))
    (if (and file (string= (file-name-extension file) "pdf"))
        (call-process "esioyek" nil 0 nil file)  ; 可替换为 zathura、evince 等
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
;; Buffers Management
;; =====================================================================

;; Buffers manipulations
(use-package ibuffer
  :ensure nerd-icons-ibuffer
  ;; :bind
  ;; ("C-x C-b" . ibuffer)
  :hook
  (ibuffer-mode . nerd-icons-ibuffer-mode)
  (ibuffer-mode . ibuffer-auto-mode)
)

(use-package activities
  :ensure t
  :init
  (activities-mode)
  (activities-tabs-mode)
  ;; Prevent `edebug' default bindings from interfering.
  ;; (setq edebug-inhibit-emacs-lisp-mode-bindings t)
  :bind
  (("C-x M-a C-n" . activities-new)
   ("C-x M-a C-d" . activities-define)
   ("C-x M-a C-a" . activities-resume)
   ("C-x M-a C-s" . activities-suspend)
   ("C-x M-a C-k" . activities-kill)
   ("C-x M-a RET" . activities-switch)
   ("C-x M-a b" . activities-switch-buffer)
   ("C-x M-a g" . activities-revert)
   ("C-x M-a l" . activities-list))
  )

(use-package perspective
  :demand t
  :ensure t
  :init
  (persp-mode)
  :bind
  ("C-x C-b" . persp-ibuffer)         ; or use a nicer switcher, see below
  ("C-x k" . persp-kill-buffer*)
  ;; ("C-x b" . persp-switch-to-buffer*)
  :config
  (setq
   persp-show-modestring nil
   persp-modestring-short nil)
  :custom
  (persp-mode-prefix-key (kbd "C-x M-p"))  ; pick your own prefix key here
  )

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
  )

(use-package vlf
  :ensure t
  :demand t
  :config
  (custom-set-variables '(large-file-warning-threshold (expt 2 22 )))
  (custom-set-variables '(vlf-application 'dont-ask))
  )

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
;; Lsp  Language supplementary enhancement
;; =====================================================================
;; reuse LSP installed by Mason for nvim
(add-to-list
 'exec-path  "~/.local/share/nvim/mason/bin/")
(use-package eglot
  :ensure t
  :hook
  ((prog-mode . (lambda ()
                  (unless (derived-mode-p
                           'emacs-lisp-mode 'lisp-mode
                           ;; 'makefile-mode
                           'snippet-mode
                           'portage-modes-env-mode
                           'portage-modes-use-mode
                           'portage-modes-generic-mode
                           'portage-modes-license-mode
                           'portage-modes-keywords-mode
                           'LaTeX-mode
                           ;; 'org-src-mode
                           )
                    (eglot-ensure))))
   ((LaTeX-mode typst-ts-mode markdown-mode yaml-mode yaml-ts-mode)
    . eglot-ensure)
   )

  :custom
  (eglot-sync-connect 1)
  (eglot-autoshutdown t)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(typst-ts-mode . ("tinymist")
                   ;; (tex-mode . ("texlab"))
                   ))

    (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
    (advice-add 'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
    )
)

;; =====================================================================
;; Treesit
;; =====================================================================
(require 'treesit)
(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install t
        global-treesit-auto-mode t
        )
  )

;; (setq treesit-extra-load-path "/usr/lib64")

(use-package typst-ts-mode
  :ensure t
  :custom
  (typst-ts-watch-options "--open")
  (typst-ts-mode-enable-raw-blocks-highlight t)
  :config
  (keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu)
  (add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode)))

;; =====================================================================
;; Moudules
;; =====================================================================

;; llm
(use-package llm
  :ensure t
  :demand t
  :config
  )
(use-package ellama
  :ensure t
  :bind
  ("C-x e" . ellama)
  ("C-x C-t" . ellama-translate)
  ;; send last message in chat buffer with C-c C-c
  :hook (org-ctrl-c-ctrl-c-hook . ellama-chat-send-last-message)
  :init
  (setopt ellama-auto-scroll t)
  ;; (setopt ellama-keymap-prefix "C-c e")
  (setopt ellama-language "中文")
  (setopt ellama-stream t)
  (setopt ellama-auto-scroll t)
  (require 'llm-deepseek)
  (setopt ellama-provider
          (make-llm-deepseek
           :default-chat-temperature 0.1
           ;; :key (getenv "DEEPSEEK_API_KEY")
           :key (plist-get (car (auth-source-search :host "deepseek.com"))
                           :secret)
           :chat-model "deepseek-v4-flash"
           ))
  (setopt ellama-translation-provider
           (make-llm-deepseek
           :default-chat-temperature 0.1
           ;; :key (getenv "DEEPSEEK_API_KEY")
           :key (plist-get (car (auth-source-search :host "deepseek.com"))
                           :secret)
           :chat-model "deepseek-v4-flash"
           ))
  (setopt ellama-chat-display-action-function
          #'display-buffer-full-frame)
  (setopt ellama-instant-display-action-function
          #'display-buffer-in-side-window)
  
  :config
  ;; show ellama context in header line in all buffers
  (ellama-context-header-line-global-mode +1)
  ;; show ellama session id in header line in all buffers
  (ellama-session-header-line-global-mode +1)
  (setopt llm-warn-on-nonfree nil)
  (setq ellama-output-remove-reasoning t)
  (setq ellama-session-remove-reasoning nil)
  (setq ellama-show-reasoning nil)
  (setq ellama-translation-template "请将将内容精确且通俗易懂的翻译为中文，除了译文无需返回任何内容")
  )

(use-package minuet
  :ensure t
  ;; :demand t
  :bind
  (("M-y" . #'minuet-complete-with-minibuffer) ;; use minibuffer for completion
   ("M-i" . #'minuet-show-suggestion) ;; use overlay for completion
   ("C-c m" . #'minuet-configure-provider)
   :map minuet-active-mode-map
   ;; These keymaps activate only when a minuet suggestion is displayed in the current buffer
   ("M-p" . #'minuet-previous-suggestion) ;; invoke completion or cycle to next completion
   ("M-n" . #'minuet-next-suggestion) ;; invoke completion or cycle to previous completion
   ("M-A" . #'minuet-accept-suggestion) ;; accept whole completion
   ;; Accept the first line of completion, or N lines with a numeric-prefix:
   ;; e.g. C-u 2 M-a will accepts 2 lines of completion.
   ("M-a" . #'minuet-accept-suggestion-line)
   ("M-e" . #'minuet-dismiss-suggestion))
  
  ;; :init
  ;; if you want to enable auto suggestion.
  ;; Note that you can manually invoke completions without enable minuet-auto-suggestion-mode
  ;; (add-hook 'prog-mode-hook #'minuet-auto-suggestion-mode)

  :config
  (setq minuet-request-timeout 2.5)
  (setq minuet-auto-suggestion-throttle-delay 1.5) ;; Increase to reduce costs and avoid rate limits
  (setq minuet-auto-suggestion-debounce-delay 0.6) ;; Increase to reduce costs and avoid rate
  ;; You can use M-x minuet-configure-provider to interactively configure provider and model
  (setq minuet-provider 'openai-fim-compatible) ;; ds by default

  ;; current :api-key use "ENV" but not support
  ;; func (plist-get ...) which was supported by lib llm
  (plist-put
   minuet-openai-fim-compatible-options
   :api-key
   (plist-get
    (car (auth-source-search :host "deepseek.com")) :secret))
  ;; Prioritize throughput for faster completion
  (minuet-set-optional-options minuet-openai-compatible-options
                               :provider '(:sort "throughput"))
  (minuet-set-optional-options minuet-openai-compatible-options
                               :max_tokens 56)
  (minuet-set-optional-options minuet-openai-compatible-options
                               :top_p 0.9)
  )

(use-package gptel
  :ensure t
  ;; :demand t
  :bind (("C-c g" . gptel-menu)
         ;; ("C-c G" . gptel-send)
         )
  :config
  (setq gptel-model 'deepseek-v4-flash
        gptel-include-reasoning t
        gptel-backend (gptel-make-deepseek "DeepSeek"
                        :key (plist-get
                              (car (auth-source-search
                                    :host "deepseek.com"))
                              :secret)
                        :stream t))
  (gptel-make-openai "minimax"
    :models '(MiniMax-M2.7)
    :key (plist-get
          (car (auth-source-search
                :host "minimaxi.com"))
          :secret)
    :endpoint "/v1"
    :protocol "https"
    :host "api.minimaxi.com"
    :stream t)
  )

;; transient posframe for gptel and ellama
(use-package transient
  :ensure transient-posframe
  :demand t
  :config
  (transient-posframe-mode)
  (setq transient-posframe-border-width 6)
  )

(use-package aidermacs
  :ensure t
  ;; :demand t
  :config
  (add-to-list 'aidermacs-extra-args "--chat-language zh_CN")
  (setq aidermacs-architect-model "deepseek/deepseek-v4-pro"
        aidermacs-editor-model "deepseek/deepseek-v4-flash"
        aidermacs-weak-model "deepseek/deepseek-v4-flash"
        aidermacs-default-chat-model 'editor
        aidermacs-comint-multiline-newline-key "S-<return>"
        aidermacs-show-diff-after-change t
        aidermacs-auto-commits t
        )
  )

;; =====================================================================
;; Eshell hooker with Eat shell emulations
;; =====================================================================
(use-package eat
  :ensure t)

(use-package eshell
  :after eat
  :hook
  (eshell-mode . eat-shell-mode)
  (eshell-mode . eat-shell-visual-command-mode)
  )

;; =====================================================================
;; multimedia
;; =====================================================================
(use-package emms
  :ensure t
  :config
  (emms-all)
  (setq emms-player-list '(emms-player-mpv)
        emms-info-functions '(emms-info-native)
        )
  (setq emms-browser-covers #'emms-browser-cache-thumbnail-async
        emms-browser-thumbnail-small-size 64
        emms-browser-thumbnail-medium-size 128
        )
  :custom
  ;; filters
  (emms-browser-make-filter "all" #'ignore)
  (emms-browser-make-filter
   "recent"
   (lambda (track) (< 30
                      (time-to-number-of-days
                       (time-subtract
                        (current-time)
                        (emms-info-track-file-mtime track))))))
  (emms-browser-set-filter (assoc "all" emms-browser-filters))
  ;; history
  (emms-history-load)
  ;; libre-fm
  (emms-librefm-scrobbler-enable)
  )

(use-package empv
  :ensure t
  :custom
  (with-eval-after-load 'embark
    (empv-embark-initialize-extra-actions))
  :config
  (setq empv-invidious-instance "https://inv.thepixora.com/api/v1"
        empv-youtube-use-tabulated-results t
        empv-reset-playback-speed-on-quit t
        empv-mpv-args
        (remove "--no-video" empv-mpv-args)
        empv-ytdl-download-options
        (remove "--extract-audio"  empv-ytdl-download-options)
        empv-ytdl-download-options
        (remove "--audio-format=mp3" empv-ytdl-download-options))
  
  (add-to-list 'empv-mpv-args
               "--ytdl-format=bv*+ba/best")
  (add-to-list 'empv-mpv-args
               "--save-position-on-quit")
  (add-to-list 'empv-ytdl-download-options
               "--format=bv*+ba/best")
  (add-to-list 'empv-ytdl-download-options
               "--embed-subs")
  
  (add-hook
   'empv-media-title-changed-hook
   (lambda (title)
     (message "Media title changed: %s" title)))

  (add-hook
   'empv-player-state-changed-hook
   (lambda (state)
     (message
      (pcase empv-player-state
        ('playing "empv is playing...")
        ('paused "empv is paused...")
        ('caching "empv is buffering...")
        ('stopped "empv is stopped...")))))

  (add-hook
   'empv-init-hook
   (lambda ()
     (empv-observe 'metadata
       (lambda (data)
         (message "Metadata changed, new metadata is: %s" data)))))
  ;; (add-hook 'empv-init-hook #'empv-override-quit-key)
  )


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
  (add-to-list 'woman-path "$MANPATH")
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
;; Modules
;; =====================================================================

(require 'init_web)
(require 'init_notes)

(setq gc-cons-threshold (* 8 1024 1024))
(provide 'init)
;;; init.el ends here
