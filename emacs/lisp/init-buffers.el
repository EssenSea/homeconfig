;;; init-buffers.el --- Buffer management -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

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

(provide 'init-buffers)
;;; init-buffers.el ends here
