;;; init-ui.el --- User interface: themes, dashboard, modeline, icons -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

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

(provide 'init-ui)
;;; init-ui.el ends here
