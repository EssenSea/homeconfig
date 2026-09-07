;;; init_web.el --- configuration for web Supplementary  -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author:  <essensea@qq.com>
;; Keywords: mail

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

;; 

;;; Code:



;;;=====================================================================
;; mail with mu4e
;;;=====================================================================

;; (use-package nano-mu4e
;; :vc (:url "https://github.com/rougier/nano-mu4e")
;;   :defer t
;; )

(use-package mu4e
  ;; :hook
  ;; (mu4e-headers-mode . nano-mu4e) ;; no comfort for current Plugins frame
  :config
  (setq mu4e-main-hide-personal-addresses t)
  (setq mu4e-split-view 'horizontal)
  (setq mu4e-headers-visible-lines 8)
  
  (setq mu4e-maildir "$HOME/.local/share/mail/")
  (setopt auth-sources '((:source "~/.authinfo.gpg" :host t :port t)))

  (setq
   mu4e-get-mail-command "mbsync -a"
   mu4e-update-interval 300)

  (with-eval-after-load "mm-decode"
    (add-to-list 'mm-discouraged-alternatives "text/html")
    (add-to-list 'mm-discouraged-alternatives "text/richtext"))

  ;; (setq shr-color-visible-luminance-min 80)
  
  (setq mu4e-context-policy 'ask)
  (setq mu4e-compose-context-policy 'ask)
  (setq mu4e-contexts
   `( ,(make-mu4e-context
        :name "qmail"
        :vars
        '((user-mail-address . "essensea@foxmail.com")
          (user-full-name . "EssenSea")
          (smtpmail-smtp-server . "smtp.qq.com")
          (smtpmail-smtp-user .  "essensea@foxmail.com")
          (mu4e-sent-folder .   "/qmail/Sent Messages/" )
          (mu4e-drafts-folder .  "/qmail/Drafts/" )
          (mu4e-trash-folder .  "/qmail/Deleted Messages/")
          (mu4e-refile-folder . "/qmail/其他文件夹/邮件归档/")
          (mu4e-maildir-shortcuts . 
                                  ((:maildir "/qmail/Archives/"          :key ?a)
                                   (:maildir "/qmail/INBOX/"             :key ?i)
                                   (:maildir "/qmail/Sent Messages/"     :key ?s)
                                   (:maildir "/qmail/Drafts/"            :key ?d)
                                   (:maildir "/qmail/Junk/"              :key ?j)))
          ))
      ,(make-mu4e-context
        :name "gmail"
        :vars
        '((user-mail-address . "yueqrgg@gmail.com")
          (user-full-name . "YUE QianRen")
          (smtpmail-smtp-server . "smtp.gmail.com")
          (smtpmail-smtp-user .  "yueqrgg@gmail.com")
          (mu4e-sent-folder .   "/gmail/[Gmail]/Sent Mail/" )
          (mu4e-drafts-folder .  "/gmail/[Gmail]/Drafts/" )
          (mu4e-trash-folder .  "/gmail/[Gmail]/Trash/")
          (mu4e-refile-folder . "/gmail/[Gmail]/Archives/")
          (mu4e-maildir-shortcuts .
                                  ((:maildir "/gmail/[Gmail]/Archive/"   :key ?a)
                                   (:maildir "/gmail/INBOX/"             :key ?i)
                                   (:maildir "/gmail/[Gmail]/Sent Mail/" :key ?s)
                                   (:maildir "/gmail/[Gmail]/Drafts/"    :key ?d)
                                   (:maildir "/gmail/[Gmail]/Spam/"      :key ?t)))
          ))
      ))
  
  (setq
   message-send-mail-function  'smtpmail-send-it
   mu4e-sent-messages-behavior  'delete
   smtpmail-smtp-service  587
   smtpmail-stream-type  'starttls)

  (setq mu4e-eldoc-support t)
  (setq mu4e-use-fancy-chars t)
  (setq mu4e-headers-results-limit 99999)
  
  (setq
   mu4e-headers-draft-mark     '("D" . ":D")
   mu4e-headers-flagged-mark   '("F" . ":F")
   mu4e-headers-new-mark       '("N" . ":N")
   mu4e-headers-passed-mark    '("P" . ":P")
   mu4e-headers-replied-mark   '("R" . ":R")
   mu4e-headers-seen-mark      '("S" . ":S")
   mu4e-headers-trashed-mark   '("T" . ":T")
   mu4e-headers-attach-mark    '("a" . ":A")
   mu4e-headers-encrypted-mark '("x" . ":E")
   mu4e-headers-signed-mark    '("s" . ":Sn")
   mu4e-headers-unread-mark    '("u" . ":N")
   mu4e-headers-list-mark      '("l" . ":LS")
   mu4e-headers-personal-mark  '("p" . ":P")
   mu4e-headers-calendar-mark  '("c" . ":C"))
  )

;;;=====================================================================
;; Usenet for news with gnus
;;;=====================================================================

(use-package gnus
  :hook
 (gnus-article-mode . (lambda ()
                      (setq shr-width fill-column)
                      (setq shr-fill-text t)))
  :config
  (setq gnus-select-method
        '(nntp "news.eternal-september.org")
        )
  ;; (setq gnus-secondary-select-methods
  ;;       '(nntp "news.gmane.io")
  ;;       )

  ;; ;; 将 Foxmail 邮箱作为第二个收信来源
  ;; (add-to-list 'gnus-secondary-select-methods
  ;;              '(nnimap "foxmail"
  ;;                       (nnimap-address "imap.foxmail.com")
  ;;                       (nnimap-server-port 993)
  ;;                       (nnimap-stream ssl)))

  ;; ;; 发信设置
  ;; ;; 1. 设置默认发信参数
  ;; (setq message-send-mail-function 'smtpmail-send-it
  ;;     smtpmail-stream-type 'starttls
  ;;     smtpmail-smtp-service 587)

  ;; ;; 2. 定义不同的发件风格
  ;; (setq gnus-posting-styles
  ;;       '(("nnimap+gmail:ALL*" ;; 默认风格
  ;;          (address "yueqrgg@gmail.com")
  ;;          (X-Message-SMTP-Method "smtp smtp.gmail.com 587")
  ;;          (signature "---\nBest,\nYueQR"))
        
  ;;       ;; 针对来自 Foxmail 邮件组的邮件，使用 Foxmail 的身份回复
  ;;         ("nnimap+foxmail:INBOX"
  ;;          (address "essensea@foxmail.com")
  ;;          (X-Message-SMTP-Method "smtp smtp.qq.com 587")
  ;;          (signature "---\n祝好\nEssenSea"))))
  ;; 优化与外观
  ;; 尝试解决可能的网络延迟问题
  (setq read-process-output-fast t)

  ;; 不显示过多的启动信息，让界面更干净
  (setq gnus-inhibit-startup-message t)

  ;; 显示图片/附件
  ;; (setq mm-text-html-renderer 'shr)
  (setq gnus-inhibit-images nil)
  )

;;;=====================================================================
;; rss reading with elfeed
;;;=====================================================================
(use-package elfeed
  :ensure t
  ;; :pin nongnu
  :config
  ;; default was "@6-months-ago +unread"
  (setq elfeed-search-filter "@12months"
        elfeed-search-separator-date-format "%W %b %Y")
  
  ;; (setq elfeed-db-directory (expand-file-name "elfeed" user-emacs-directory))
  ;; (setq elfeed-enclosure-default-dir
        ;; (expand-file-name "elfeed" user-emacs-directory))
  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" null_prog)
        ;; "https://planet.emacslife.com/atom.xml" 
        ;; "https://emacsredux.com/atom.xml"
          ("https://planet.emacslife.com/atom.xml" emacslife)
          ("https://planet.guix.gnu.org/atom.xml" guix)
          ("http://www.masteringemacs.org/feed/" mastering)
          ("https://oremacs.com/atom.xml" oremacs)
          ("https://pinecast.com/feed/emacscast" emacscast)
          ("https://emacstil.com/feed.xml" Emacs TIL)
          ;; ("https://www.reddit.com/r/emacs.rss" reddit emacs)
          ;; ("https://www.reddit.com/r/Gentoo.rss" Gentoo)
          ("https://www.chiply.dev/rss.xml" chiply)
          ("https://undeadly.org/cgi?action=rss" openbsd))
      ))

;;;=====================================================================
;; web protocol gopher and gemini with elpher
;;;=====================================================================
(use-package elpher
  :ensure t
  )

(provide 'init_web)
;;; init_web.el ends here
