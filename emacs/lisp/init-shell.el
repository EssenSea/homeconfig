;;; init-shell.el --- Shell and multimedia: Eat, Eshell, EMMS, EMPV -*- lexical-binding: t; -*-

;;; Commentary:

;; 本文件由 init.el 拆分而来。

;;; Code:

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

(provide 'init-shell)
;;; init-shell.el ends here
