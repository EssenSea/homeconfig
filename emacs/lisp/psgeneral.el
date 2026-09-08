;;; psgeneral.el --- Purcell 有而我没有/相反的通用小工具与通用化启用项 -*- lexical-binding: t -*-
;;; Commentary:

;; 本文件是参考 ~/SrcRepo/purcell（Purcell 全套配置）后整理出来的
;; “通用工具 / 生活化小包”候选清单。
;;
;; 原则：
;; 1. 只收入我目前配置里没有、或与我当前设置“直接相反”的通用化启用项；
;; 2. 不收入我已经在用的包（vertico/corfu/cape/consult/which-key/avy/
;;    magit/undo-fu/rainbow-delimiters/wgrep/vlf/dashboard/... 等）；
;; 3. 全部写成我习惯的 use-package 风格，方便逐个保留 / 注释；
;; 4. 所有条目都带中文注释，说明“有什么用 / Purcell 怎么做 / 和我现在有何不同”。
;;
;; 尚未在 init.el 中 require，请仔细阅读后自行决定是否并入。
;; 若要测试：在 init.el 的 Configuration modules 中加入
;;            (require 'psgeneral)
;; 即可（注意也会 require 本文件里列出的各个包）。

;;; Code:

;; =====================================================================
;; A. 基础编辑行为 / 通用开关（大多是内置功能，直接启用或修正默认值）
;; =====================================================================

(use-package emacs
  :config
  ;; ---------- 与“备份”相关的相反项（来自 Purcell init-editing-utils.el）----------
  ;; Purcell 倾向“不留垃圾”，关闭锁文件/备份/自动保存。
  ;; 注意：你在 init.el 里明确开启了 make-backup-files / auto-save-default，
  ;;       所以下面三项如果采用会直接改变你的备份策略。想保留你自己的备份时，
  ;;       只关 create-lockfiles 即可（锁文件纯粹是残留物）。
  (setq create-lockfiles nil)            ; 不生成 #file# 锁文件（Emacs 崩溃后常残留）
  ;; (setq auto-save-default nil)        ; 不自动保存（Purcell 默认，谨慎，与你的备份偏好相反）
  ;; (setq make-backup-files nil)        ; 不生成 ~ 备份文件（Purcell 默认，与你的备份偏好相反）

  ;; ---------- 编辑/光标/窗口通用行为 ----------
  (electric-indent-mode 1)               ; 自动缩进模式（你已开 electric-pair 但没开这个）
  (repeat-mode 1)                        ; 允许重复执行 C-x 类命令（C-x u u u ... 等）
  (transient-mark-mode 1)                ; 显式选区高亮（现代 Emacs 默认，但显式开启更稳）

  ;; Purcell 把这些放在 setq-default，认为更符合日常习惯：
  (setq-default
   mouse-yank-at-point t                 ; 中键粘贴到光标处而不是鼠标点击处
   save-interprogram-paste-before-kill t ; kill 之前先保存外部剪贴板，避免丢失系统粘贴内容
   scroll-preserve-screen-position 'always ; 滚动时尽量保持屏幕位置不变
   set-mark-command-repeat-pop t         ; 连续 C-x C-x 可反复在“上一标记”之间跳转
   truncate-lines nil                    ; 默认不截断长行，让 so-long/visual-line 接管
   truncate-partial-width-windows nil)   ; 分栏窄窗口里也不截断
  (setq-default blink-cursor-interval 0.4) ; 光标闪烁速度（略快一点更跟手）
  (setq-default tooltip-delay 1.5)         ; 稍晚显示 tooltip，减少打扰

  ;; ---------- 解除 Purcell 认为没必要的“确认限制” ----------
  ;; 默认 Emacs 对 narrowing / 大小写转换会要求 yes/no，Purcell 全部解除。
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'narrow-to-defun 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)

  ;; ---------- GUI 基础（Purcell init-gui-frames.el，多数与你 early-init 一致，补漏）----------
  (setq use-file-dialog nil              ; 不用系统文件对话框（Emacs 内补全文件更快）
        use-dialog-box nil
        inhibit-startup-screen t         ; 不显示启动画面
        frame-title-format               ; 标题栏直接显示当前文件名
        '((:eval (if (buffer-file-name)
                     (abbreviate-file-name (buffer-file-name))
                   "%b"))))

  ;; C-z 在 TTY 下才真正挂起 Emacs；图形界面下 C-z 默认会最小化/挂起，容易误触
  (defun psgeneral/maybe-suspend-frame ()
    "只有 TTY 下才允许 C-z 产生 suspend-frame 效果。"
    (interactive)
    (unless (display-graphic-p)
      (suspend-frame)))
  (global-set-key (kbd "C-z") #'psgeneral/maybe-suspend-frame)

  ;; 布局相关的一般优化
  (setq-default window-combination-resize t) ; 窗口重新分配更“按比例”
  (when (fboundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode))          ; 像素级精确滚动（新版 Emacs）

  ;; ---------- 基础按键习惯（Purcell init-editing-utils.el）----------
  ;; M-j 常用于“合并行”而非你绑定的 avy-goto-char-timer；
  ;; 注意：你已在 init-tools.el 把 M-j 绑定给 avy，若想保留这套习惯请改键。
  ;; (global-set-key (kbd "M-j") 'join-line)
  (global-set-key (kbd "M-Z") 'zap-up-to-char)      ; M-Z：删除到前一个字符（与 M-z 互反）
  (global-set-key (kbd "C-M-<backspace>")          ; 从光标删到行首非空白处
                  (lambda ()
                    (interactive)
                    (let ((prev-pos (point)))
                      (back-to-indentation)
                      (kill-region (point) prev-pos))))
  ;; Purcell 建议放弃 M-left/right 而用 M-f/M-b 训练词移动，顺带省键位
  (global-unset-key [M-left])
  (global-unset-key [M-right])

  ;; ---------------- 会话/历史（Purcell init-sessions.el） ----------------
  ;; 你已经有 savehist-mode；Purcell 另外会持久保存“打开的桌面会话”。
  ;; 若想要“下次启动恢复现场”，放开下面两行测试。
  ;; (setq desktop-path (list user-emacs-directory)
  ;;       desktop-auto-save-timeout 600)
  ;; (desktop-save-mode 1)

  ;; ---------- buffer 重名显示策略（Purcell init-uniquify.el） ----------
  ;; 不同目录下的同名文件打开后，Emacs 默认显示 filename<2>；
  ;; 改成 reverse 风格“目录信息后缀”后更直观，如 a.txt<~/proj1/>。
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'reverse
        uniquify-separator " • "
        uniquify-after-kill-buffer-p t
        uniquify-ignore-buffers-re "^\\*")

  ;; ---------- 主题/安全设置（Purcell init-themes.el 中通用部分） ----------
  ;; 首次加载新主题不再反复询问“是否信任该主题”
  (setq custom-safe-themes t)

  ;; ---------- 杂项通用（Purcell init-misc.el） ----------
  ;; 用 y/n 代替 yes/no 长确认（更快的日常反馈）
  (if (boundp 'use-short-answers)
      (setq use-short-answers t)
    (fset 'yes-or-no-p 'y-or-n-p))
  ;; 保存脚本文件后若发现 shebang 自动赋予可执行权限
  (add-hook 'after-save-hook
            #'executable-make-buffer-file-executable-if-script-p)
  ;; 在 Program/Conf 模式中把网址/邮箱变成可点击链接
  (add-hook 'prog-mode-hook #'goto-address-prog-mode)
  (add-hook 'conf-mode-hook #'goto-address-prog-mode)
  (setq goto-address-mail-face 'link)

  ;; ---------- 通用 mode / help 增强 ----------
  ;; 有可用 eldoc 的 buffer 都显示行内文档（你已用 eglot/flymake 等，
  ;; 该设置保证其它支持 eldoc 的主模式也统一享受）
  (when (fboundp 'global-eldoc-mode)
    (global-eldoc-mode 1))
  ;; C-h A 直接查看某个 face（Purcell 加的常用帮助入口）
  (with-eval-after-load 'help
    (define-key help-map "A" #'describe-face))

  ;; ---------- 通用文件操作小函数（Purcell init-utils.el） ----------
  ;; 这三个函数不依赖包，直接提供高频“删除/重命名/浏览器打开当前文件”。
  (defun psgeneral/delete-this-file ()
    "删除当前文件并关闭对应 buffer。"
    (interactive)
    (unless (buffer-file-name)
      (error "No file is currently being edited"))
    (when (yes-or-no-p
           (format "Really delete '%s'?"
                   (file-name-nondirectory (buffer-file-name))))
      (delete-file (buffer-file-name))
      (kill-buffer)))
  (global-set-key (kbd "C-c D") #'psgeneral/delete-this-file)

  (defun psgeneral/rename-this-file-and-buffer (new-name)
    "同时把当前 buffer 和磁盘文件重命名为 NEW-NAME。"
    (interactive "sNew name: ")
    (let ((name (buffer-name))
          (filename (buffer-file-name)))
      (unless filename
        (error "Buffer '%s' is not visiting a file!" name))
      (when (file-exists-p filename)
        (rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name)))
  (global-set-key (kbd "C-c R") #'psgeneral/rename-this-file-and-buffer)

  (defun psgeneral/browse-current-file ()
    "用系统浏览器打开当前文件对应的 file:// URL。"
    (interactive)
    (let ((file-name (buffer-file-name)))
      (if (and (fboundp 'tramp-tramp-file-p)
               (tramp-tramp-file-p file-name))
          (error "Cannot open tramp file")
        (browse-url (concat "file://" file-name)))))
  (global-set-key (kbd "C-c B") #'psgeneral/browse-current-file)
  )

;;; --- 窗口像素尺寸 / 字号缩放（Purcell init-gui-frames） ---
;; 窗口按像素缩放更平滑（新版 Emacs 通常默认，这里显式开启）
(use-package emacs
  :ensure nil
  :config
  (setq-default window-resize-pixelwise t
                frame-resize-pixelwise t))

;; 全局字号缩放：C-x C-+ / C-x C-- / C-x C-0
;; （Purcell 还用来绑定 C-M-滚轮，这里保留基础键即可）
(use-package default-text-scale
  :ensure t
  :hook (after-init . default-text-scale-mode)
  :config
  (dolist (bind '("C-<wheel-down>" "C-<wheel-up>"
                  "C-<mouse-4>" "C-<mouse-5>"))
    (define-key global-map (kbd bind) nil)))

;; =====================================================================
;; B. 编辑“生活化小包”（Purcell 有、我目前没有）
;; =====================================================================

;; 没有区域时，复制/剪切/删除都自动作用于整行——日常高频省操作
(use-package whole-line-or-region
  :ensure t
  :hook (after-init . whole-line-or-region-global-mode))

;; 上下移动/复制整行（M-S-up / M-S-down / C-c d / C-c u）
(use-package move-dup
  :ensure t
  :bind (("M-S-<up>"   . move-dup-move-lines-up)
         ("M-S-<down>" . move-dup-move-lines-down)
         ("C-c d"      . move-dup-duplicate-down)
         ("C-c u"      . move-dup-duplicate-up)))

;; 多光标编辑（Purcell 经典键位）
(use-package multiple-cursors
  :ensure t
  :bind (("C-<"       . mc/mark-previous-like-this)
         ("C->"       . mc/mark-next-like-this)
         ("C-c C-<"   . mc/mark-all-like-this)))

;; 显示当前查询/替换匹配数，并让 n/N 在匹配间跳转
(use-package anzu
  :ensure t
  :hook (after-init . global-anzu-mode)
  :bind (([remap query-replace]       . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)))

;; 高亮当前符号，并在同符号之间跳转（M-i / M-n / M-p）
(use-package symbol-overlay
  :ensure t
  :hook ((prog-mode-hook  . symbol-overlay-mode)
         (html-mode-hook  . symbol-overlay-mode)
         (yaml-mode-hook  . symbol-overlay-mode)
         (conf-mode-hook  . symbol-overlay-mode))
  :bind (:map symbol-overlay-mode-map
         ("M-i" . symbol-overlay-put)
         ("M-I" . symbol-overlay-remove-all)
         ("M-n" . symbol-overlay-jump-next)
         ("M-p" . symbol-overlay-jump-prev)))

;; 可浏览杀环（kill-ring）：
;; 你有 consult-yank-pop，但想要“列表浏览 + 搜索”时可加这个
(use-package browse-kill-ring
  :ensure t
  :bind ("M-Y" . browse-kill-ring)
  :custom (browse-kill-ring-separator "\f")
  :config
  (with-eval-after-load 'browse-kill-ring
    (define-key browse-kill-ring-mode-map (kbd "C-g") #'browse-kill-ring-quit)
    (define-key browse-kill-ring-mode-map (kbd "M-n") #'browse-kill-ring-forward)
    (define-key browse-kill-ring-mode-map (kbd "M-p") #'browse-kill-ring-previous)))

;; 智能扩展选区（C-= 逐级扩大）
(use-package expreg
  :ensure t
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract)))

;; 页分隔线美化（^L 分页符显示为一条横线）
(use-package page-break-lines
  :ensure t
  :hook (after-init . global-page-break-lines-mode))

;; 高亮字符串里的转义序列（如 \n \t），写代码时很直观
(use-package highlight-escape-sequences
  :ensure t
  :hook (after-init . hes-mode))

;; 高亮“已引用”的符号（Lisp 中带引号列表项）
(use-package highlight-quoted
  :ensure t
  :hook ((emacs-lisp-mode . highlight-quoted-mode)
         (lisp-mode       . highlight-quoted-mode)))

;; 文本“反向填充”：把已折行的段落重新并成整段
(use-package unfill
  :ensure t)

;; 终端下也有效的可见“响铃”（模式行闪烁代替蜂鸣）
(use-package mode-line-bell
  :ensure t
  :hook (after-init . mode-line-bell-mode))

;; 让 mode-line 更干净（隐藏 minor-mode 的“占位文字”）
;; 注意：需要配合 :ensure t 安装 diminish
(use-package diminish
  :ensure t)

;; Info/帮助手册彩色化
(use-package info-colors
  :ensure t
  :config
  (with-eval-after-load 'info
    (add-hook 'Info-selection-hook #'info-colors-fontify-node)))

;; 保存时自动清除行尾空白 / 多余空行（Purcell init-whitespace.el）
;; 注意：如果你不希望“保存即清理”，可注释；它会改变文件内容。
(use-package whitespace-cleanup-mode
  :ensure t
  :hook (after-init . global-whitespace-cleanup-mode)
  :config
  (when (fboundp 'diminish)
    (diminish 'whitespace-cleanup-mode)))

;; 在 prog/text/conf 模式显示行尾空格，帮助主动发现“脏空白”
(use-package emacs
  :ensure nil
  :config
  (defun psgeneral/show-trailing-whitespace ()
    "本 buffer 显示行尾空白。"
    (setq-local show-trailing-whitespace t))
  (dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
    (add-hook hook #'psgeneral/show-trailing-whitespace))
  ;; 把“压缩多个空格”换成 cycle-spacing（可循环 1/多/全空格）
  (global-set-key [remap just-one-space] 'cycle-spacing))

;; Unicode 字符浏览辅助（查看某 font 支持的字符/别称，Purcell 的小工具）
;; (use-package list-unicode-display
;;   :ensure t)

;; =====================================================================
;; C. 文件 / Dired / Ibuffer
;; =====================================================================

;; Dired 增强（Purcell init-dired.el）：
;; - 双击/回车打开目标文件
;; - C-c C-q 进入 wdired 直接批量改文件名
;; - C-x C-j 快速跳到当前目录的 Dired（dired-jump）
;; - 粘贴/复制时自动猜测对侧 Dired 目录（dired-dwim-target）
(use-package dired
  :ensure nil                       ; 内置
  :custom
  (dired-dwim-target t              ; 双栏 Dired 时自动把目标放到另一栏
   dired-recursive-deletes 'top     ; 删除目录递归时“顶部确认一次”
   dired-listing-switches "-alh")   ; 与你在 init-files 中一致，此处仅作示例
  :config
  (define-key ctl-x-map "\C-j" 'dired-jump)
  (define-key ctl-x-4-map "\C-j" 'dired-jump-other-window)
  (with-eval-after-load 'dired
    (define-key dired-mode-map (kbd "C-c C-q") #'wdired-change-to-wdired-mode)
    (define-key dired-mode-map [mouse-2] #'dired-find-file)))
;; 注：你已有自己的 dired 配置（图标+PDF 外部打开+autorevert）。
;;     若并入本文件，需把重复的 RET/mouse 等键位错开或取舍。

;; 彩色文件类型 Dired（Purcell 风格，配合 nerd-icons-dired 可二选一）
(use-package diredfl
  :ensure t
  :after dired
  :config
  (diredfl-global-mode)
  (require 'dired-x))

;; Dired / 编辑区里显示版本控制改动标记
;; 同时补上 Purcell init-vc.el：Magit 刷新后同步高亮、fringe 点击跳转 hunk、
;; M-C-[ / M-C-] 在改动块之间前后跳。
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)
  (with-eval-after-load 'dired
    (add-hook 'dired-mode-hook #'diff-hl-dired-mode))
  (with-eval-after-load 'diff-hl
    (define-key diff-hl-mode-map (kbd "<left-fringe> <mouse-1>")
      #'diff-hl-diff-goto-hunk)
    (define-key diff-hl-mode-map (kbd "M-C-]") #'diff-hl-next-hunk)
    (define-key diff-hl-mode-map (kbd "M-C-[") #'diff-hl-previous-hunk)))

;; 代码/区域折叠：Purcell 用 origami（你目前已在 prog-mode 启用 hs-minor-mode，
;; 二者会冲突，因此默认整段注释；若想换用 origami 再放开）
;; (use-package origami
;;   :ensure t
;;   :config
;;   (define-key origami-mode-map (kbd "C-c f") #'origami-recursively-toggle-node)
;;   (define-key origami-mode-map (kbd "C-c F") #'origami-toggle-all-nodes))

;; Ibuffer：按 Git/VC 根分组，显示人类可读大小、VC 相对路径等
;; Purcell 会整框打开；我这里尽量用你现有风格整合
(use-package ibuffer
  :ensure ibuffer-vc                ; 先确保依赖
  :bind ("C-x C-b" . ibuffer)
  :hook (ibuffer-mode . ibuffer-auto-mode)
  :config
  (defun psgeneral/ibuffer-group-by-vc ()
    "按版本控制根目录给 ibuffer 分组，默认按文件名排序。"
    (ibuffer-vc-set-filter-groups-by-vc-root)
    (unless (eq ibuffer-sorting-mode 'filename/process)
      (ibuffer-do-sort-by-filename/process)))

  (add-hook 'ibuffer-mode-hook #'psgeneral/ibuffer-group-by-vc)
  (setq-default ibuffer-show-empty-filter-groups nil))

;; =====================================================================
;; D. 窗口管理
;; =====================================================================

;; 记住窗口布局，可撤销窗口改动（winner-undo）
(use-package winner
  :ensure nil
  :hook (after-init . winner-mode))

;; C-x o 可视化“选窗口”（多个窗口时弹出字母快捷选择）
;; Purcell 用的是 switch-window；你目前用 switchy-window。
;; 二者理念不同：switch-window 是“按一下 C-x o 再按字母”，
;; switchy-window 是“长按等待选目标”。喜欢哪套取决于你。
(use-package switch-window
  :ensure t
  :custom
  (switch-window-shortcut-style 'qwerty)
  (switch-window-timeout nil)
  :bind ("C-x o" . switch-window))  ; 如果你更习惯 switchy-window 就注释掉此项

;; 方向键切换窗口 windmove + windswap
(use-package windswap
  :ensure t
  :config
  (windmove-default-keybindings 'control)          ; C-<left/right/up/down> 切换窗口
  (windswap-default-keybindings 'shift 'control))  ; C-S-<方向> 交换窗口

;; 当前动作时给光标/区域一个“闪烁提示”反馈（Purcell 用于 mwim/mc 等场景）
(use-package pulsar
  :ensure t
  :custom
  (pulsar-pulse-region-functions nil)
  :hook (after-init . pulsar-global-mode))

;; =====================================================================
;; E. 工程 / Git
;; =====================================================================

;; Projectile：若你更接受“传统工程管理”可启用；否则保留 project.el
;; （Purcell 为它设了 rg 加速、ibuffer-projectile、C-c p 前缀）
(use-package projectile
  :ensure t
  :custom
  (projectile-mode-line-prefix " Proj")
  (projectile-generic-command "rg --files --hidden -0") ; 优先 ripgrep 加速
  :bind ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1))

;; Ibuffer 显示所属工程/目录（要配 projectile 才会更显价值）
(use-package ibuffer-projectile
  :ensure t
  :after projectile
  :config
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-projectile-set-filter-groups)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

;; Git：逐版本“时光机”浏览当前文件历史
(use-package git-timemachine
  :ensure t
  :bind ("C-x v t" . git-timemachine-toggle))

;; Git：生成当前 hunk/commit/file 的网页链接，方便贴到 issue/PR
(use-package git-link
  :ensure t)

;; Magit：补齐 Purcell 常用增强
;; 说明：你只是 (use-package magit :ensure t)，很多顺手设置还没接上
(use-package magit
  :ensure t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :custom
  (magit-diff-refine-hunk 'all)          ; diff 中自动精化 hunk 高亮
  (magit-diff-visit-prefer-worktree t)   ; 打开 diff 中文件时优先工作区内容
  :config
  ;; 在非 macOS / 终端以外系统也提供 M-F12 打开任意已登记仓库
  (global-set-key [(meta f12)] #'magit-status))

;; Magit 一站式显示未处理 TODO 标记
(use-package magit-todos
  :ensure t
  :after magit)

;; =====================================================================
;; F. 搜索 / isearch / grep / compile
;; =====================================================================

;; isearch 增强：从搜索直接升级为 consult-line（保留“整行搜索结果”视角）
(use-package emacs
  :ensure nil
  :config
  (with-eval-after-load 'isearch
    ;; 让 DEL 只删搜索串里的字符，而不是回退上一步搜索
    (define-key isearch-mode-map
      [remap isearch-delete-char] #'isearch-del-char)

    (defun psgeneral/isearch-consult-line ()
      "把当前 isearch 关键字转成 consult-line 列表继续多行浏览。"
      (interactive)
      (let ((query (if isearch-regexp
                       isearch-string
                     (regexp-quote isearch-string))))
        (isearch-update-ring isearch-string isearch-regexp)
        (let (search-nonincremental-instead)
          (ignore-errors (isearch-done t t)))
        (consult-line query)))
    (define-key isearch-mode-map (kbd "C-o") #'psgeneral/isearch-consult-line)

    ;; C-M-w：把光标处的完整“符号”作为正则打入搜索框
    (defun psgeneral/isearch-yank-symbol ()
      "把当前符号原样作为正则式搜索串。"
      (interactive)
      (let ((sym (thing-at-point 'symbol)))
        (if sym
            (progn
              (setq isearch-regexp t
                    isearch-string (concat "\\_<" (regexp-quote sym) "\\_>")
                    isearch-message (mapconcat 'isearch-text-char-description
                                               isearch-string "")
                    isearch-yank-flag t))
          (ding)))
      (isearch-search-and-update))
    (define-key isearch-mode-map (kbd "C-M-w") #'psgeneral/isearch-yank-symbol)

    ;; C-RET 在搜索结果“另一端”退出 isearch，方便直接接 kill/copy
    (defun psgeneral/isearch-exit-other-end ()
      "退出 isearch 并跳到搜索串另一端。"
      (interactive)
      (isearch-exit)
      (goto-char isearch-other-end))
    (define-key isearch-mode-map [(control return)]
      #'psgeneral/isearch-exit-other-end)))

;; grep 输出/编译输出 ANSI 彩色 + 常用键位
(use-package compile
  :ensure nil
  :custom
  (compilation-scroll-output t)   ; 编译输出自动跟随滚动（可选）
  :config
  (require 'ansi-color)
  (defun psgeneral/colourise-compilation-buffer ()
    "把编译输出中的 ANSI 颜色转成真彩色。"
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook #'psgeneral/colourise-compilation-buffer)
  ;; 常用键位：F6 直接重新编译
  (global-set-key [f6] 'recompile)
  ;; wgrep（你已有）之外，再给 grep 模式补几个移动键位不成问题
  (with-eval-after-load 'grep
    (dolist (key (list (kbd "C-c C-q") (kbd "w")))
      (define-key grep-mode-map key #'wgrep-change-to-wgrep-mode))))

;; 编译完成且 buffer 被隐藏时，用系统通知提醒
(use-package alert
  :ensure t)

;; =====================================================================
;; G. 环境 / PATH / 外部工具入口
;; =====================================================================

;; 从登录 shell 导入 PATH/环境变量（GUI 下 Emacs 经常拿不到 .bashrc/.zshrc 的 PATH）
(use-package exec-path-from-shell
  :ensure t
  :if (or (memq window-system '(mac ns x pgtk))
          (unless (memq system-type '(ms-dos windows-nt))
            (daemonp)))
  :config
  (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID"
                 "GPG_AGENT_INFO" "LANG" "LC_CTYPE"
                 "NIX_SSL_CERT_FILE" "NIX_PATH"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))

;; direnv / .envrc 集成（每个目录自动加载环境）
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode)
  :bind ("C-c e" . envrc-command-map))

(provide 'psgeneral)
;;; psgeneral.el ends here
