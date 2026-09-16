vim9script
# =============================================================================
# Filename:   autoload/mutedstatus.vim
# Purpose:    Self-contained "muted" statusline for Vim 9.
#             Bundles both the colour backend (derives washed-out
#             foreground/background pairs from the active colourscheme) and the
#             native statusline front end (components + %#group# assembly).
# 用途：一个自包含的 Vim 9 "失色" 状态栏模块，同时包含取色后端（从当前配色
#       推导淡化的前景/背景色对）与原生状态栏前端（组件 + %#高亮组# 拼装）。
#
# Enable with / 启用方式:
#   call mutedstatus#Setup()
#
# Public API / 公共接口:
#   Colours / 取色:
#     mutedstatus#Colors()          resolved chunk templates
#     mutedstatus#Hi(group, chunk)  apply one chunk to a highlight group
#     mutedstatus#Apply(groups)     apply {group: 'ordinary'|'emphasis'}
#     mutedstatus#ApplyDefault()    apply the default group scheme
#   Statusline / 状态栏:
#     mutedstatus#Mode() ... mutedstatus#String()   components / assembly
#     mutedstatus#Setup() / mutedstatus#Refresh()   install / refresh
#
# Options (g:mutedstatus# namespace) / 选项（g:mutedstatus# 命名空间）:
#   g:mutedstatus#theme   source theme; '' = current colourscheme
#   g:mutedstatus#invert  1 swaps foreground and background
#   g:mutedstatus#fg      explicit foreground override
#   g:mutedstatus#bg      explicit background override
# Accepted value formats / 可用取值格式:
#   '#RRGGBB', color name, 256-color index, 'NONE'
# =============================================================================

# --- option lookup -----------------------------------------------------------
# 选项查询：仅认 g:mutedstatus#* 命名空间。
const opt_ns = 'mutedstatus#'

def OptVar(name: string): string
  var key = opt_ns .. name
  return exists('g:' .. key) ? key : ''
enddef

# Whether an option variable is set to a usable (non-empty) value.
# Accepts numbers (256-colour indices) and non-empty strings; anything else is
# treated as unset.  Kept separate from OptVar() because comparing a number to
# '' directly is a type error in Vim9 script.
# 选项变量是否已设为可用（非空）值。数字（256 色号）与非空字符串视为可用，
# 其余视为未设置。与 OptVar() 分开是因为 Vim9 中数字与 '' 直接比较会报类型错误。
def OptSet(var: string): bool
  if empty(var) || !exists('g:' .. var)
    return false
  endif
  var val = get(g:, var, '')
  if type(val) == v:t_number
    return true
  endif
  return type(val) == v:t_string && !empty(val)
enddef

def Opt(name: string, default: any): any
  var key = opt_ns .. name
  return exists('g:' .. key) ? get(g:, key) : default
enddef

# --- 256-color conversion helpers -------------------------------------------
# 256 色转换辅助函数。
const probe = '_MutedStatusProbe'

def Black(x: number): number
  if x < 0x04
    return 16
  elseif x > 0xf4
    return 231
  elseif index([0x00, 0x5f, 0x87, 0xaf, 0xdf, 0xff], x) >= 0
    var l: number = x / 0x30
    return ((l * 6) + l) * 6 + l + 16
  else
    return 232 + (x < 8 ? 0 : x < 0x60 ? (x - 8) / 10 : x < 0x76 ? (x - 0x60) / 6 + 9 : (x - 8) / 10)
  endif
enddef

def Nr(x: number): number
  return x < 0x2f ? 0 : x < 0x73 ? 1 : x < 0x9b ? 2 : x < 0xc7 ? 3 : x < 0xef ? 4 : 5
enddef

# Convert '#RRGGBB' (or colour name) to a 256-colour index.
# 将 '#RRGGBB'（或颜色名）转为 256 色号。
def GuiToCterm(color: string): number
  var rgb = matchlist(color, '#\(..\)\(..\)\(..\)')
  if empty(rgb)
    # Ask Vim to resolve a colour name to '#RRGGBB'.
    # 让 Vim 把颜色名解析为 '#RRGGBB'。
    silent! execute $'highlight {probe} guifg={color}'
    var hex = synIDattr(hlID(probe), 'fg#')
    silent! highlight clear _MutedStatusProbe
    if !empty(hex) && hex =~# '^#'
      rgb = matchlist(hex, '#\(..\)\(..\)\(..\)')
    else
      return 0
    endif
  endif
  var r = str2nr(rgb[1], 16)
  var g = str2nr(rgb[2], 16)
  var b = str2nr(rgb[3], 16)
  if r == 0xc0 && g == 0xc0 && b == 0xc0
    return 7
  elseif r == 0x80 && g == 0x80 && b == 0x80
    return 8
  elseif (r == 0x80 || r == 0x00) && (g == 0x80 || g == 0x00) && (b == 0x80 || b == 0x00)
    return (r / 0x80) + (g / 0x80) * 2 + (g / 0x80) * 4
  elseif abs(r - g) < 3 && abs(g - b) < 3 && abs(b - r) < 3
    return Black((r + g + b) / 3)
  else
    return 16 + ((Nr(r) * 6) + Nr(g)) * 6 + Nr(b)
  endif
enddef

# Convert a 256-colour index to an approximate '#RRGGBB'.
# 将 256 色号转为近似的 '#RRGGBB'。
def NrToHex(n: number): string
  if n < 0
    return '#000000'
  elseif n < 16
    const basic = [
      '#000000', '#800000', '#008000', '#808000',
      '#000080', '#800080', '#008080', '#c0c0c0',
      '#808080', '#ff0000', '#00ff00', '#ffff00',
      '#0000ff', '#ff00ff', '#00ffff', '#ffffff',
    ]
    return basic[n]
  elseif n < 232
    var m = n - 16
    const levels = [0x00, 0x5f, 0x87, 0xaf, 0xdf, 0xff]
    var r = levels[m / 36]
    var g = levels[(m % 36) / 6]
    var b = levels[m % 6]
    return printf('#%02x%02x%02x', r, g, b)
  else
    var k = (n - 232) * 10 + 8
    return printf('#%02x%02x%02x', k, k, k)
  endif
enddef

# Normalise a synIDattr(..., '#') result.
# Vim returns '#RRGGBB' when a GUI colour is set, but when only cterm colours
# exist (e.g. 'termguicolors' off and t_Co=256) it returns the 256-colour index
# as a string ('188').  Treat such a value as a cterm index so we never emit
# `guifg=188` (which raises E254).
# 归一化 synIDattr(..., '#') 的结果。存在 GUI 颜色时返回 '#RRGGBB'；只有 cterm
# 色时返回 256 色号字符串（'188'）。把后者当作 cterm 色号，避免输出 `guifg=188`
# 触发 E254。
# Returns [gui, cterm]; gui is '' for a cterm-only value.
# 返回 [gui, cterm]；只有 cterm 色时 gui 为空串。
def NormalizeGui(gui: string, cterm: string): list<string>
  var g = gui
  var c = cterm
  if !empty(g) && g !~# '^#'
    if g =~# '^\d\+$'
      # Numeric value is a cterm index, not a GUI colour.
      # 数字值是 cterm 色号，不是 GUI 颜色。
      c = g
      g = ''
    else
      # A colour name (e.g. 'red'): ask Vim to resolve it to '#RRGGBB'.
      # 颜色名（如 'red'）：交给 Vim 解析成 '#RRGGBB'。
      silent! execute $'highlight {probe} guifg={g}'
      var hex = synIDattr(hlID(probe), 'fg#')
      silent! execute $'highlight clear {probe}'
      if !empty(hex) && hex =~# '^#'
        g = hex
      endif
    endif
  endif
  return [g, c]
enddef

# --- resolve one colour into a [gui, cterm] pair -----------------------------
# 将单个颜色解析为 [gui, cterm] 对。
def ResolvePair(var: string, attr: string): list<string>
  var val = get(g:, var, '')
  if type(val) == v:t_number
    return [NrToHex(val), string(val)]
  elseif type(val) == v:t_string && !empty(val)
    if val ==# 'NONE'
      return ['NONE', 'NONE']
    elseif val =~# '^\d\+$'
      var n = str2nr(val)
      return [NrToHex(n), val]
    elseif val =~# '^#'
      return [val, string(GuiToCterm(val))]
    else
      silent! execute $'highlight {probe} guifg={val}'
      var hex = synIDattr(hlID(probe), 'fg#')
      silent! execute $'highlight clear {probe}'
      if !empty(hex) && hex =~# '^#'
        return [hex, string(GuiToCterm(hex))]
      endif
      return [val, string(GuiToCterm(val))]
    endif
  endif
  # Default: current Normal fg/bg. Keep NONE transparent.
  # 默认：当前 Normal 的前景/背景色。保持 NONE 透明。
  var gui = synIDattr(hlID('Normal'), attr .. '#')
  var cterm = synIDattr(hlID('Normal'), attr, 'cterm')
  var norm = NormalizeGui(gui, cterm)
  if empty(norm[0]) || norm[0] ==# 'NONE'
    return ['NONE', empty(norm[1]) ? 'NONE' : norm[1]]
  endif
  return [norm[0], empty(norm[1]) ? string(GuiToCterm(norm[0])) : norm[1]]
enddef

# --- read a named theme's opaque Normal fg/bg --------------------------------
# 读取指定主题非透明的 Normal 前景/背景。
const transparent_opts = [
  'everforest_transparent_background',
  'catppuccin_transparent_background',
  'iceberg_transparent_background',
  'tokyonight_transparent_background',
]

def ReadThemeColors(theme: string): list<string>
  var orig = get(g:, 'colors_name', '')
  var switched = false
  var orig_bg_opt = &background
  var saved: dict<number> = {}
  for var in transparent_opts
    if exists('g:' .. var)
      saved[var] = get(g:, var, 0)
      # ':let' is unavailable in Vim9 script; set the global by name instead.
      # Vim9 中不能用 :let，改为按变量名设置全局变量。
      g:[var] = 0
    endif
  endfor
  if !empty(theme)
    try
      noautocmd execute $'colorscheme {theme}'
      switched = true
    catch
      switched = false
    endtry
  endif
  var fg_gui = synIDattr(hlID('Normal'), 'fg#')
  var bg_gui = synIDattr(hlID('Normal'), 'bg#')
  var fg_cterm = synIDattr(hlID('Normal'), 'fg', 'cterm')
  var bg_cterm = synIDattr(hlID('Normal'), 'bg', 'cterm')
  if switched && !empty(orig)
    silent! noautocmd execute $'colorscheme {orig}'
  endif
  &background = orig_bg_opt
  for [var, val] in items(saved)
    g:[var] = val
  endfor
  return [fg_gui, bg_gui, fg_cterm, bg_cterm]
enddef

def PairFrom(gui: string, cterm: string): list<string>
  var norm = NormalizeGui(gui, cterm)
  if empty(norm[0]) || norm[0] ==# 'NONE'
    return ['NONE', empty(norm[1]) ? 'NONE' : norm[1]]
  endif
  return [norm[0], empty(norm[1]) ? string(GuiToCterm(norm[0])) : norm[1]]
enddef

def ThemePair(attr: string): list<string>
  var theme = Opt('theme', '')
  var c = ReadThemeColors(theme)
  if attr ==# 'fg'
    return PairFrom(c[0], c[2])
  else
    return PairFrom(c[1], c[3])
  endif
enddef

# --- public colour API -------------------------------------------------------
# 公共取色接口。

# Return the resolved muted colours as a dictionary with two chunk templates:
#   {'ordinary': [fg_pair, bg_pair], 'emphasis': [fg_pair, bg_pair],
#    'fg': fg_pair, 'bg': bg_pair, 'invert': 0/1, 'is_none': 0/1}
# 返回解析后的 muted 颜色，含两个区块模板（ordinary/emphasis）及辅助字段。
export def Colors(): dict<any>
  var invert: number = Opt('invert', 0)
  var fg_var = OptVar('fg')
  var bg_var = OptVar('bg')

  var s_fg: list<string> = OptSet(fg_var)
    ? ResolvePair(fg_var, 'fg')
    : (invert ? ThemePair('bg') : ThemePair('fg'))

  var s_bg: list<string> = OptSet(bg_var)
    ? ResolvePair(bg_var, 'bg')
    : (invert ? ThemePair('fg') : ThemePair('bg'))

  var dark = &background !=# 'light'
  var def_fg: list<string> = dark ? ['#ffffff', '15'] : ['#000000', '0']
  var def_bg: list<string> = dark ? ['#000000', '0'] : ['#ffffff', '15']

  var fg_none = s_fg[0] ==# 'NONE'
  var bg_none = s_bg[0] ==# 'NONE'
  var is_none = fg_none || bg_none

  var ordinary: list<any>
  var emphasis: list<any>
  if is_none
    # NONE request: start from the derived concrete pair, then restore any
    # half the user explicitly set (transparent fg with an opaque bg, or
    # vice versa) so an explicit colour is never silently discarded.
    # NONE 请求：先取推导出的实色对，再把用户显式设定的那一半还原回去
    # （透明前景 + 实背景，或反之），避免显式颜色被无声丢弃。
    var filled = [copy(def_fg), copy(def_bg)]
    var emptied = [['NONE', 'NONE'], ['NONE', 'NONE']]
    ordinary = invert ? filled : emptied
    emphasis = invert ? emptied : filled
    if invert
      # ordinary is the filled chunk / ordinary 为填充块
      if !fg_none
        ordinary[0] = copy(s_fg)
      endif
      if !bg_none
        ordinary[1] = copy(s_bg)
      endif
    else
      # emphasis is the filled chunk / emphasis 为填充块
      if !fg_none
        emphasis[0] = copy(s_fg)
      endif
      if !bg_none
        emphasis[1] = copy(s_bg)
      endif
    endif
  else
    ordinary = [copy(s_fg), copy(s_bg)]
    emphasis = [copy(s_bg), copy(s_fg)]
  endif

  return {
    ordinary: ordinary,
    emphasis: emphasis,
    fg: copy(s_fg),
    bg: copy(s_bg),
    invert: invert,
    is_none: is_none,
  }
enddef

# Apply one [fg_pair, bg_pair] chunk to a highlight group.
# 把一个 [前景对, 背景对] 区块应用到某个高亮组。
export def Hi(group: string, chunk: list<any>): void
  var fg = chunk[0]
  var bg = chunk[1]
  execute $'highlight {group} guifg={fg[0]} guibg={bg[0]} ctermfg={fg[1]} ctermbg={bg[1]}'
enddef

# Apply a dict of {group_name: 'ordinary'|'emphasis'} using the muted colours.
# 用 muted 颜色把 {组名: 'ordinary'|'emphasis'} 应用出去。
export def Apply(groups: dict<string>): void
  var c = Colors()
  for [group, kind] in items(groups)
    var chunk = get(c, kind, c.ordinary)
    Hi(group, chunk)
  endfor
enddef

# Convenience: apply the default muted statusline group scheme.
# 便捷：应用默认的 muted statusline 高亮组方案。
export def ApplyDefault(): void
  Apply({
    MutedStatusMode: 'emphasis',
    MutedStatusFile: 'ordinary',
    MutedStatusRight: 'ordinary',
    MutedStatusError: 'emphasis',
    MutedStatusWarning: 'emphasis',
    MutedStatusInactive: 'ordinary',
  })
enddef

# =============================================================================
# Statusline front end / 状态栏前端
# =============================================================================

# --- component content (pure text, no colours) ------------------------------
# 组件内容（纯文本，不含颜色）。
# Full-mode names: keys are the value of mode(1) (the complete mode string).
# 完整模式名：键为 mode(1) 的值（完整模式串）。
const mode_full: dict<string> = {
  'n': 'NORMAL',
  'no': 'NORMAL',
  'nov': 'NORMAL',
  'noV': 'NORMAL',
  "no\<C-v>": 'NORMAL',
  'niI': 'NORMAL',
  'niR': 'NORMAL',
  'niV': 'NORMAL',
  'nt': 'TERM-N',
  'v': 'VISUAL',
  'vs': 'VISUAL',
  'V': 'V-LINE',
  'Vs': 'V-LINE',
  "\<C-v>": 'V-BLOCK',
  "\<C-v>s": 'V-BLOCK',
  's': 'SELECT',
  'S': 'S-LINE',
  "\<C-s>": 'S-BLOCK',
  'i': 'INSERT',
  'ic': 'INSERT-C',
  'ix': 'INSERT-X',
  'R': 'REPLACE',
  'Rc': 'REPLACE-C',
  'Rx': 'REPLACE-X',
  'Rv': 'V-REPLACE',
  'Rvc': 'V-REPLACE-C',
  'Rvx': 'V-REPLACE-X',
  'c': 'COMMAND',
  'ct': 'CMD-TERM',
  'cr': 'CMD-REPLACE',
  'cv': 'EX',
  'cvr': 'EX-REPLACE',
  'ce': 'EX-NORMAL',
  'r': 'HIT-ENTER',
  'rm': 'MORE',
  'r?': 'CONFIRM',
  '!': 'SHELL',
  't': 'TERMINAL',
}

# Single-letter fallback for any future/unknown mode strings.
# 单字母回退，用于未来/未知模式串。
const mode_single: dict<string> = {
  'n': 'NORMAL',
  'v': 'VISUAL',
  'V': 'V-LINE',
  's': 'SELECT',
  'S': 'S-LINE',
  'i': 'INSERT',
  'R': 'REPLACE',
  'c': 'COMMAND',
  'r': 'PROMPT',
  '!': 'SHELL',
  't': 'TERMINAL',
}

# Return a human readable mode string, recognising composite modes.
# An optional argument overrides the mode string (mainly for testing).
# 返回可读的模式字样，支持组合状态识别。可选参数用于覆盖模式串（主要用于测试）。
export def Mode(...args: list<any>): string
  var full: string = len(args) > 0 ? args[0] : mode(1)
  if has_key(mode_full, full)
    return mode_full[full]
  endif
  if empty(full)
    return ''
  endif
  # Fall back to the leading character (mode() semantics).
  # 回退到首字符（mode() 语义）。
  var first = full[0]
  if has_key(mode_full, first)
    return mode_full[first]
  endif
  if has_key(mode_single, first)
    return mode_single[first]
  endif
  return full
enddef

export def Paste(): string
  return &paste ? 'PASTE' : ''
enddef

# ALE diagnostics (empty when ALE is unavailable). / ALE 诊断（不可用时为空）。
# def AleCount(kind: string): number
#   if !exists('*ale#statusline#Count')
#     return 0
#   endif
#   var c = ale#statusline#Count(bufnr(''))
#   if kind ==# 'error'
#     return c.error + c.style_error
#   else
#     return c.warning + c.style_warning
#   endif
# enddef

# export def AleErrors(): string
#   var n = AleCount('error')
#   return n ? printf('E:%d', n) : ''
# enddef

# export def AleWarnings(): string
#   var n = AleCount('warning')
#   return n ? printf('W:%d', n) : ''
# enddef

# Whether the window currently being rendered is the active window.
# The '%!' expression and 'statusline' are evaluated per window with
# g:statusline_winid bound to that window, so this is safe to call from
# inside mutedstatus#String().
# 正在渲染的窗口是否为当前活动窗口。'%!' 表达式和 statusline 会按窗口求值，
# 此时 g:statusline_winid 指向该窗口，因此在 mutedstatus#String() 内调用安全。
export def IsActive(): bool
  return !exists('g:statusline_winid') || win_getid() == g:statusline_winid
enddef

# Pick the group name for a logical chunk, using the inactive variant when the
# rendered window is not the current one.
# 为逻辑区块选高亮组名；被渲染的窗口非当前窗口时使用 inactive 变体。
def Group(name: string, inactive: string): string
  return IsActive() ? name : inactive
enddef

# --- assemble the statusline string ------------------------------------------
# 组装 statusline 字符串。
# Uses the highlight groups defined by ApplyDefault():
#   MutedStatusMode / MutedStatusFile / MutedStatusRight /
#   MutedStatusError / MutedStatusWarning / MutedStatusInactive
# Inactive windows map every chunk to MutedStatusInactive so the current
# window stands out.
# 使用 ApplyDefault() 定义的高亮组。非活动窗口的所有区块映射到
# MutedStatusInactive，从而突出当前窗口。
export def String(): string
  var mode_g  = Group('MutedStatusMode',    'MutedStatusInactive')
  var file_g  = Group('MutedStatusFile',    'MutedStatusInactive')
  var right_g = Group('MutedStatusRight',   'MutedStatusInactive')
  # var error_g = Group('MutedStatusError',   'MutedStatusInactive')
  # var warn_g  = Group('MutedStatusWarning', 'MutedStatusInactive')

  var s = ''
  # mode chunk (emphasis) / 模式区块（强调）
  s ..= $'%#{mode_g}# %{{mutedstatus#Mode()}}%{{mutedstatus#Paste()}} '
  # file chunk (ordinary) / 文件区块（普通）
  # '%<' marks the truncation point: long paths are shortened here first so
  # the right-aligned section is never pushed off screen.
  # '%<' 标记截断点：长路径优先在此缩短，右侧区块不会被挤出屏幕。
  # '%t' = file name (tail); '%m' = modified [+] / nomodifiable [-];
  # '%r' = readonly [RO].  All three are native statusline items, so no
  # helper functions are needed.
  # '%t' = 文件名（尾段）；'%m' = 已修改 [+] / 不可修改 [-]；'%r' = 只读 [RO]。
  # 三者都是 statusline 内建项，无需辅助函数。
  s ..= $' %#{file_g}# %( %<%t %)'
  s ..= '%m%r'
  # diagnostics (emphasis) / 诊断（强调）
  # s ..= $'%#{error_g}#%{{mutedstatus#AleErrors()}}'
  # s ..= $'%#{warn_g}#%{{mutedstatus#AleWarnings()}}'
  # right side / 右侧
  s ..= $'%#{right_g}#%= %y | Buf:%n | %P of %LL | [%l:%c] | UNIX '
  return s
enddef

# --- color refresh -----------------------------------------------------------
# 颜色刷新。
# Highlight groups only depend on the source theme and 'background'; they do
# NOT depend on the mode or on which window is focused (active/inactive is
# resolved per-window at render time via g:statusline_winid).  Refresh
# therefore only needs to run on ColorScheme/background changes.
# 高亮组只依赖来源主题与 'background'，不依赖模式或当前窗口（活动/非活动在渲染
# 时通过 g:statusline_winid 逐窗口解析）。因此只需在 ColorScheme/background
# 变化时刷新。
export def Refresh(): void
  ApplyDefault()
enddef

# Redraw the statusline only when it is safe to do so.
# Calling redrawstatus during startup or while Vim is shutting down makes Vim
# emit extra terminal state sequences (cursor blink/visibility, kitty keyboard
# protocol resets).  Under kitty those late writes leave artifacts on screen
# after exit, so never redraw while `v:dying` is set.
# 仅在安全时重绘状态栏。在启动阶段或 Vim 退出过程中调用 redrawstatus 会让 Vim
# 额外输出终端状态序列（光标闪烁/可见性、kitty 键盘协议复位）。在 kitty 下这些
# 迟到的写入会在退出后留下残影，因此 v:dying 置位时绝不重绘。
export def Redraw(): void
  if exists('v:dying') && v:dying
    return
  endif
  redrawstatus
enddef

# Install the statusline and the refresh autocmds.
# 安装状态栏与刷新自动命令。
export def Setup(): void
  Refresh()
  set statusline=%!mutedstatus#String()
  augroup mutedstatus
    autocmd!
    # Highlights change only with the colourscheme/'background'.
    # 仅在配色或 'background' 变化时刷新高亮。
    autocmd ColorScheme * mutedstatus#Refresh() | mutedstatus#Redraw()
    autocmd OptionSet background mutedstatus#Refresh() | mutedstatus#Redraw()
    # Diagnostics alter the statusline text while editing; redraw then.
    # 诊断内容在编辑时变化，需重绘状态栏。
    # autocmd User ALELint,ALEIndexInvalidate mutedstatus#Redraw()
  augroup END
enddef
