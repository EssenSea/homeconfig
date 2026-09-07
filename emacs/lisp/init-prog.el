;;; init-prog.el --- Programming: LSP, Tree-sitter, AI assistants -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

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
;; 31.1 内置 tree-sitter：启用所有可用 ts 模式。
;; 注意须用 customize-set-variable 触发 defcustom 的 :set，
;; 它才会把各语言 remap 到内置 *-ts-mode。
(customize-set-variable 'treesit-enabled-modes t)

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

(provide 'init-prog)
;;; init-prog.el ends here
