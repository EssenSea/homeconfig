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
(require 'package)
(setq package-quickstart t)
(setq package-archives
      '(("gnu"
         . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu"
         . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"
         . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; (package-initialize)
(package-activate-all)
(require 'use-package)
(setq package-native-compile t)

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
(electric-indent-mode t)
(auto-fill-mode t)           ; 启用自动折行
(delete-selection-mode t)    ; 覆盖选中文本

(setq
 display-time-load-average nil
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
  (
   ;; (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ;; Lookup the current symbol at point.  C-c C-d is a common keybinding for
   ;; this in Lisp modes.
   ("C-c C-d" . helpful-at-point)
   ;; By default, C-h F is bound to `Info-goto-emacs-command-node'.  Helpful
   ;; already links to the manual, if a function is referenced there.
   ("C-h F" . helpful-function)))



;; =====================================================================
;; Configuration modules
;; =====================================================================

(require 'init-ui)
(require 'init-files)
(require 'init-buffers)
(require 'init-tools)
(require 'init-completion)
(require 'init-prog)
(require 'init-shell)
(require 'init-system)
(require 'init_web)
(require 'init_notes)

(setq gc-cons-threshold (* 8 1024 1024))
(provide 'init)

;;; init.el ends here
