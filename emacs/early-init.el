;;; early-init.el --- earlier initialized file       -*- lexical-binding: t; -*-

;; Copyright (C) 2026

;; Author:  <moonsea@gentoo>
;; Keywords: lisp

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

;; (when (boundp 'pgtk-wait-for-event-timeout)
  ;; (setq pgtk-wait-for-event-timeout 0.001))

(setq gc-cons-threshold most-positive-fixnum)

;; (setq
 ;; inhibit-startup-screen t
 ;; inhibit-default-init t
 ;; inhibit-splash-screen t
 ;; inhibit-x-resources t
 ;; inhibit-bidi-mirroring t
 ;; inhibit-startup-message t
 ;; inhibit-startup-echo-area-message t
 ;; inhibit-startup-buffer-menu t
 ;; inhibit-startup-hooks t
      ;; )

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)


(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

(advice-add #'display-startup-screen :override #'ignore)
(setq-default redisplay-dont-pause t)

(setq initial-scratch-message nil)
;; 6. 全局延迟 use-package
(setq package-enable-at-startup nil
      use-package-always-defer t
      )
(defvar my-cpu-architecture "skylake")

;; `native-comp-compiler-options' specifies flags passed directly to the C
;; compiler (for example, GCC) when compiling the Lisp-to-C output
;; produced by the native compilation process. These flags affect code
;; generation, optimization, and debugging information.
(setq native-comp-compiler-options '("-O2"
                                     "-g0"
                                     "-fomit-frame-pointer"
                                     "-fno-finite-math-only"))

;; `native-comp-driver-options' specifies additional flags passed to the native
;; compilation driver process, which may invoke the compiler and linker with
;; certain parameters.
(setq native-comp-driver-options `(,(format "-mtune=%s" my-cpu-architecture)
                                   ,(format "-march=%s" my-cpu-architecture)))

(defun my-add-package-info-dirs ()
  "把已安装且带 info 文档的包的目录加入 `Info-directory-list'。"
  (require 'info)
  (info-initialize)
  (when (bound-and-true-p package-alist)
    (dolist (entry package-alist)
      (dolist (desc (cdr entry))
        (let ((dir (package-desc-dir desc)))
          (when (file-exists-p (expand-file-name "dir" dir))
            (add-to-list 'Info-directory-list dir)))))))
(add-hook 'after-init-hook #'my-add-package-info-dirs)

(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 8 1024 1024))))


(provide 'early-init)
;;; early-init.el ends here
