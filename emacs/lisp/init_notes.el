;;; init_notes.el --- notes config with org-mode and latex relative  -*- lexical-binding: t; -*-

;; Copyright (C) 2026  EssenSea

;; Author: EssenSea;;   -*- lexical-binding: t; -*- <essensea@foxmail.com>
;; Keywords: tex, local, convenience

;;; Commentary:

;;; Code:

;;;=====================================================================
;;  Reading
;;;=====================================================================
(use-package nov
  :ensure t)
;; =====================================================================
;; orgmode
;; =====================================================================
;;package named unconfortable
;; (use-package paper-skimming
;;   :vc
;;   (:url "https://github.com/101scholar/paper-skimming"
;; :lisp-dir "paper-skimming")
;;   :config
;;   (require 'paper-skimmig))
;; (:local-repo "~/.emacs.d/custom/paper-skimming/"))

;;; not think which is a completed package
;; (use-package ox-typst
;;   :vc
;;   (:url"https://github.com/jmpunkt/ox-typst")
;;   :after org)

;;; use `org-superstar', which is less dependences
;; (use-package svg-tag-mode
;;   :vc (:url "https://github.com/rougier/svg-tag-mode")
;;   :defer t
;;   :after org)
;; (use-package notebook-mode
;;   :vc (:url "https://github.com/rougier/notebook-mode")
;;   :defer t
;;   :after org)


(use-package org-superstar
  :ensure t)
;; (use-package org-modern
;; :ensure t)

;; 当启用 org-indent-mode 时，修正 current-fill-column 函数
(defun my-org-indent-fill-column-advice (res)
  "根据当前行的视觉缩进长度，调整 'current-fill-column' 的返回值 RES ."
  (cond ((and (boundp 'org-indent-mode) org-indent-mode)
         (- res (length (plist-get (text-properties-at (point))
                                   'line-prefix))))
        (t res)))
(advice-add 'current-fill-column
            :filter-return #'my-org-indent-fill-column-advice)

(use-package ox-typst
  :ensure t
  :after org)
(use-package org
  :ensure t
  :init
  (setq org-highlight-latex-and-related '(native latex entities))
  
  :hook
  (org-mode . org-cdlatex-mode)
  (org-mode . org-superstar-mode)
  ;; (org-mode . org-modern-mode)
  (org-mode . auto-fill-mode)
  
  :custom
  ;; LaTeX 代码的 prettify
  (org-pretty-entities nil)
  ;; 上下标
  (org-pretty-entities-include-sub-superscripts nil)
  (org-format-latex-options
   '(:foreground default :background default
		         :scale 1.8 :html-foreground "Black"
		         :html-background "Transparent"
		         :html-scale 1.0
		         :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")
		         ))
  ;; 增大公式预览的图片大小
  :config
  (require 'ox-beamer)
  (require 'ox-md)
  (require 'ox-typst)
  ;; (require 'ox-typst)
  (setq org-file-apps
      (append '(("\\.pdf\\'" . "sioyek '%s'"))
              org-file-apps))
  (setq
   org-latex-create-formula-image-program 'xelatex
   org-beamer-frame-level 3
   ;; Edit settings
   org-auto-align-tags t
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content nil

   org-attach-use-inheritance t
   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   ;; org-ellipsis "…"
   org-ellipsis "⤵"
   org-startup-with-inline-images t

   ;; Agenda styling
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "◀── now ─────────────────────────────────────────────────"

   org-startup-indented t
   ;; org-log-done 'time
   org-log-done 'note
   org-todo-keywords
   '((sequence "TODO(t)" "WAIT(w!)" "|" "DONE(d!)" "CANCEL(c!/@)")
     (sequence "READ(r!)" "REVIEW(!/@)" "PRACTISE(p!/@)"
		       "NOTE(n!/@)" "AMEMDMEMTS(a!/@)" "|" "FINISHED(f!/@)"))

   org-latex-packages-alist '(("" "amsmath")    ; 数学公式
                              ("" "amssymb")    ; 数学符号
                              ("" "bm")            ; 加粗符号
                              ("" "NotesTeXV3")
                              ("" "ctex")
                              ;; ("" "hyperref")   ; 交叉引用
                              ("left=2cm, right=2cm, top=2cm,
        bottom=2cm, headheight=15pt, includefoot" "geometry" )
                              ))
  (with-eval-after-load 'ox-latex
    (setq org-latex-compiler "lualatex"
          org-latex-pdf-process
	      '("lualatex -shell-escape -interaction nonstopmode
  -output-directory %o %f" "lualatex -shell-escape -interaction
  nonstopmode -output-directory %o %f" "lualatex -shell-escape
  -interaction nonstopmode -output-directory %o %f")))


  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")))
  )

(use-package org-roam
  :after org
  :ensure t
  :defer t
  :config
  (org-roam-db-autosync-mode))


;;;=====================================================================
;;; auctex and cdlatex for tex mode
;;;=====================================================================

(use-package cdlatex
  :ensure t
  :after tex
  )

;; (use-package preview-auto
;;   :ensure t
;;   :after tex
;;   :config
;;   (setq preview-locating-previews-message nil
;;         preview-protect-point t
;;         preview-leave-open-previews-visible t
;;         )
;;   :custom
;;   (preview-auto-interval 0.1))

(setq TeX-engine 'luatex)

(use-package tex
  :ensure
  auctex
  :bind ([remap Tex-complete-symbol] . completion-at-point-functions)
  :hook(
  (LaTeX-mode . cdlatex-mode)
  (LaTeX-mode . reftex-mode)
  (LaTeX-mode . outline-minor-mode)
  (LaTeX-mode . TeX-fold-mode)
  (LaTeX-mode . tempel-abbrev-mode)
  (LaTeX-mode . yas-minor-mode)
  (LaTeX-mode . auto-fill-mode)
  (LaTeX-mode . TeX-source-correlate-mode)
  ;; (LaTeX-mode . preview-auto-setup)
  ;; (LaTeX-mode . prettify-symbols-mode)
  
  (LaTeX-mode . (lambda ()
                  (add-to-list 'completion-at-point-functions #'cape-tex)
                  (add-to-list 'completion-at-point-functions #'yasnippet-capf)
                  ;; (add-to-list 'completion-at-point-functions #'eglot-completion-at-point)
                  )
              ))
  :config

  (setq
   TeX-auto-save t
   TeX-parse-self t
   preview-image-type 'dvi*

   TeX-PDF-mode t
   TeX-source-correlate-mode t
   TeX-source-correlate-method 'synctex
   TeX-debug-commands t

   TeX-view-program-selection '((output-pdf "Sioyek"))
   ;; for indentation
   TeX-basic-offset 4
   LaTeX-indent-level 4
   LaTeX-item-indent -2
   reftex-label-illegal-re "[^-[:alnum:]_+=:;,.]"
   ;; default value list is more comprehensive, keep commentary for future
   ;; useable
   
   ;; LaTeX-indent-environment-list '(("verbatim" current-indentation)
   ;; ("verbatim*" current-indentation) ("align" LaTeX-indent-tabular)
   ;; ("align*" LaTeX-indent-tabular) ("tabular" LaTeX-indent-tabular)
   ;; ("tabular*" LaTeX-indent-tabular)) LaTeX-indent-style 'auto)

   ;; set TeX-engine glbally to be xetex is enough, keep here as for example,
   ;; Guess never be used
   
   ;; (eval-after-load "tex"
   ;;   '(progn
   ;;      (add-to-list 'TeX-command-list
   ;;                   '("Lualatex" "lualatex -synctex=1 -shell-escape %t"
   ;;                     TeX-run-command t t :help "Run Lualatex") t)))
   )
  :custom
  (LaTeX-preview-setup t)
  (reftex-plug-into-AUCTeX t)
  (TeX-output-extension "pdf")
  )


(provide 'init_notes)
;;; init_notes.el ends here
