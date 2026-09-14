" =============================================================================
" Filename:   autoload/lightline/colorscheme/muted.vim
" Purpose:    A deliberately "washed out" lightline palette.
" 用途：刻意做成“失色”效果的 lightline 调色板。
"
" Behavior / 行为:
"   - Foreground: defaults to the current colorscheme's Normal foreground.
"     Override with g:lightline#colorscheme#muted#fg.
"   - Background: defaults to the current colorscheme's Normal background.
"     Override with g:lightline#colorscheme#muted#bg.
"   - Theme source: g:lightline#colorscheme#muted#theme can name ANY available
"     colorscheme; its Normal foreground/background are then used. Default is
"     empty, meaning the currently active colorscheme.  When reading a theme,
"     known transparency switches are forced off so its OPAQUE colors are
"     obtained (a transparent theme still yields a real background color).
"   - Invert: g:lightline#colorscheme#muted#invert (boolean, default 0) swaps
"     the chosen theme's foreground and background for lightline.
"   - A NONE foreground/background is kept: lightline then inherits the
"     terminal's default foreground/background.
"   - Emphasis by inversion (mode first-left chunk and diagnostics) always
"     stays opposite to the ordinary chunks. With a NONE theme, 'background'
"     defines concrete colors (dark fg=#ffffff bg=#000000; light the reverse):
"     when invert=1 ordinary chunks use those colors reversed while emphasis
"     inherits; when invert=0 emphasis uses them reversed while ordinary
"     inherits. For a real theme, emphasis is simply fg/bg swapped.
"   前景色：默认取当前配色主题 Normal 的前景色；
"           可通过 g:lightline#colorscheme#muted#fg 覆盖。
"   背景色：默认取当前配色主题 Normal 的背景色；
"           可通过 g:lightline#colorscheme#muted#bg 覆盖。
"   来源主题：g:lightline#colorscheme#muted#theme 可指定任意可用主题名，
"           取该主题的前景/背景色；默认空 = 当前主题。读取主题时会强制关闭
"           已知的透明开关，从而得到其“非透明”的前景/背景色（透明主题也能
"           取到真实背景色）。
"   反转：g:lightline#colorscheme#muted#invert（布尔，默认 0）会把所选主题的
"           前景与背景互换后作为 lightline 的前景/背景。
"   前景/背景若为 NONE 则保持 NONE：此时 lightline 继承终端默认的前景/背景。
"   强调反转（normal/insert/replace/visual 的左侧首块与诊断信息）始终与普通块
"   方向相反。NONE 主题下由 'background' 定义具体色（dark: fg=#ffffff,
"   bg=#000000；light 反之）：invert=1 时普通块用定义色反转、强调块继承；
"   invert=0 时强调块用定义色反转、普通块继承。实色主题下强调块即 fg/bg 互换。
"   强调（反转）：normal/insert/replace/visual 的左侧第一个区块（mode）以及
"   诊断信息区块（error/warning）会交换前景与背景。若区块背景为 NONE
"   （继承外观），则跳过反转。
"
" Accepted override formats (both fg and bg) / 可用覆盖格式（前景与背景通用）:
"   let g:lightline#colorscheme#muted#fg = '#D3C6AA'   " GUI hex / GUI 十六进制
"   let g:lightline#colorscheme#muted#fg = 'red'       " color name / 颜色名
"   let g:lightline#colorscheme#muted#fg = 187         " 256-color index / 256 色号
"   let g:lightline#colorscheme#muted#bg = 'NONE'      " transparent / 透明
"   let g:lightline#colorscheme#muted#theme = 'catppuccin'  " any theme / 任意主题
"   let g:lightline#colorscheme#muted#invert = 1       " swap fg/bg / 交换前后景
" =============================================================================

" --- 256-color conversion helpers (same algorithm as lightline) ------------
" --- 256 色转换辅助函数（与 lightline 相同算法）---------------------------

function! s:black(x) abort
  if a:x < 0x04
    return 16
  elseif a:x > 0xf4
    return 231
  elseif index([0x00, 0x5f, 0x87, 0xaf, 0xdf, 0xff], a:x) >= 0
    let l = a:x / 0x30
    return ((l * 6) + l) * 6 + l + 16
  else
    return 232 + (a:x < 8 ? 0 : a:x < 0x60 ? (a:x-8)/10 : a:x < 0x76 ? (a:x-0x60)/6+9 : (a:x-8)/10)
  endif
endfunction

function! s:nr(x) abort
  return a:x < 0x2f ? 0 : a:x < 0x73 ? 1 : a:x < 0x9b ? 2 : a:x < 0xc7 ? 3 : a:x < 0xef ? 4 : 5
endfunction

" Convert '#RRGGBB' (or color name) to a 256-color index.
" 将 '#RRGGBB'（或颜色名）转为 256 色号。
function! s:gui_to_cterm(color) abort
  let l:rgb = matchlist(a:color, '#\(..\)\(..\)\(..\)')
  if empty(l:rgb)
    " Try a color name via lightline's rgb table. / 尝试用 lightline 色表解析颜色名。
    let l:named = lightline#colortable#name_to_rgb(a:color)
    if len(l:named) == 3
      let l:rgb = ['', printf('%02x', l:named[0]), printf('%02x', l:named[1]), printf('%02x', l:named[2])]
    else
      return 0
    endif
  endif
  let l:r = 0 + ("0x" . l:rgb[1])
  let l:g = 0 + ("0x" . l:rgb[2])
  let l:b = 0 + ("0x" . l:rgb[3])
  if l:r == 0xc0 && l:g == 0xc0 && l:b == 0xc0
    return 7
  elseif l:r == 0x80 && l:g == 0x80 && l:b == 0x80
    return 8
  elseif (l:r == 0x80 || l:r == 0x00) && (l:g == 0x80 || l:g == 0x00) && (l:b == 0x80 || l:b == 0x00)
    return (l:r / 0x80) + (l:g / 0x80) * 2 + (l:g / 0x80) * 4
  elseif abs(l:r - l:g) < 3 && abs(l:g - l:b) < 3 && abs(l:b - l:r) < 3
    return s:black((l:r + l:g + l:b) / 3)
  else
    return 16 + ((s:nr(l:r) * 6) + s:nr(l:g)) * 6 + s:nr(l:b)
  endif
endfunction

" Convert a 256-color index to an approximate '#RRGGBB'.
" 将 256 色号转为近似的 '#RRGGBB'。
function! s:nr_to_hex(n) abort
  let l:n = a:n
  if l:n < 0
    return '#000000'
  elseif l:n < 16
    let l:basic = [
          \ '#000000', '#800000', '#008000', '#808000',
          \ '#000080', '#800080', '#008080', '#c0c0c0',
          \ '#808080', '#ff0000', '#00ff00', '#ffff00',
          \ '#0000ff', '#ff00ff', '#00ffff', '#ffffff',
          \ ]
    return l:basic[l:n]
  elseif l:n < 232
    let l:n -= 16
    let l:levels = [0x00, 0x5f, 0x87, 0xaf, 0xdf, 0xff]
    let l:r = l:levels[l:n / 36]
    let l:g = l:levels[(l:n % 36) / 6]
    let l:b = l:levels[l:n % 6]
    return printf('#%02x%02x%02x', l:r, l:g, l:b)
  else
    let l:k = (l:n - 232) * 10 + 8
    return printf('#%02x%02x%02x', l:k, l:k, l:k)
  endif
endfunction

" --- Resolve one color into a [gui, cterm] pair ----------------------------
" --- 将单个颜色解析为 [gui, cterm] 对 -------------------------------------

function! s:resolve_pair(var, attr) abort
  let l:val = get(g:, a:var, '')
  " Explicit override / 显式覆盖
  if type(l:val) == type(0)
    return [s:nr_to_hex(l:val), l:val]
  elseif type(l:val) == type('') && !empty(l:val)
    if l:val ==# 'NONE'
      return ['NONE', 'NONE']
    elseif l:val =~# '^\d\+$'
      let l:n = str2nr(l:val)
      return [s:nr_to_hex(l:n), l:n]
    elseif l:val =~# '^#'
      return [l:val, s:gui_to_cterm(l:val)]
    else
      " Color name: ask Vim to resolve it to '#RRGGBB'.
      " 颜色名：交给 Vim 解析为 '#RRGGBB'。
      silent! execute 'highlight _MutedProbe guifg=' . l:val
      let l:hex = synIDattr(hlID('_MutedProbe'), 'fg#')
      silent! highlight clear _MutedProbe
      if !empty(l:hex) && l:hex =~# '^#'
        return [l:hex, s:gui_to_cterm(l:hex)]
      endif
      return [l:val, s:gui_to_cterm(l:val)]
    endif
  endif
  " Default: current Normal fg/bg. Keep NONE transparent.
  " 默认：当前 Normal 的前景/背景色。保持 NONE 透明。
  let l:gui = synIDattr(hlID('Normal'), a:attr . '#')
  let l:cterm = synIDattr(hlID('Normal'), a:attr, 'cterm')
  if empty(l:gui) || l:gui ==# 'NONE'
    return ['NONE', empty(l:cterm) ? 'NONE' : l:cterm]
  endif
  return [l:gui, empty(l:cterm) ? s:gui_to_cterm(l:gui) : l:cterm]
endfunction

" Read a named theme's Normal foreground/background by temporarily applying
" it (without triggering ColorScheme autocmds) and restoring the original.
" 通过临时应用（不触发 ColorScheme 自动命令）并恢复原主题，读取指定主题
" Normal 的前景/背景色。
" Known per-theme transparent-background switches, forced off while reading
" so we always obtain the theme's opaque foreground/background.
" 已知的各主题透明背景开关；读取时强制关闭，以取到主题的非透明前景/背景。
let s:transparent_opts = [
      \ 'everforest_transparent_background',
      \ 'catppuccin_transparent_background',
      \ 'iceberg_transparent_background',
      \ 'tokyonight_transparent_background',
      \ ]

function! s:read_theme_colors(theme) abort
  let l:orig = get(g:, 'colors_name', '')
  let l:switched = 0
  " Save 'background' too: loading some colorschemes changes it, and the
  " inversion emphasis relies on the original value.
  " 一并保存 'background'：部分配色会在加载时改动它，而反转强调依赖原值。
  let l:orig_bg_opt = &background
  " Temporarily disable transparency for the theme we are about to read.
  " 临时关闭即将读取主题的透明设置。
  let l:saved = {}
  for l:var in s:transparent_opts
    if exists('g:' . l:var)
      let l:saved[l:var] = get(g:, l:var, 0)
      execute 'let g:' . l:var . ' = 0'
    endif
  endfor
  if !empty(a:theme)
    " Re-apply even when the requested theme equals the current one, so that
    " the transparency switches forced above actually take effect.
    " 即使请求主题与当前主题相同也重新加载，使上面强制关闭的透明开关生效。
    try
      noautocmd execute 'colorscheme ' . a:theme
      let l:switched = 1
    catch
      let l:switched = 0
    endtry
  endif
  let l:fg_gui = synIDattr(hlID('Normal'), 'fg#')
  let l:bg_gui = synIDattr(hlID('Normal'), 'bg#')
  let l:fg_cterm = synIDattr(hlID('Normal'), 'fg', 'cterm')
  let l:bg_cterm = synIDattr(hlID('Normal'), 'bg', 'cterm')
  " Restore original colorscheme. / 恢复原主题。
  if l:switched && !empty(l:orig)
    silent! noautocmd execute 'colorscheme ' . l:orig
  endif
  " Restore 'background'. / 恢复 'background'。
  let &background = l:orig_bg_opt
  " Restore transparency switches. / 恢复透明开关。
  for [l:var, l:val] in items(l:saved)
    execute 'let g:' . l:var . ' = ' . l:val
  endfor
  return [l:fg_gui, l:bg_gui, l:fg_cterm, l:bg_cterm]
endfunction

" Build a [gui, cterm] pair from raw gui/cterm values, keeping NONE.
" 用原始 gui/cterm 值构造 [gui, cterm] 对，并保留 NONE。
function! s:pair_from(gui, cterm) abort
  if empty(a:gui) || a:gui ==# 'NONE'
    return ['NONE', empty(a:cterm) ? 'NONE' : a:cterm]
  endif
  return [a:gui, empty(a:cterm) ? s:gui_to_cterm(a:gui) : a:cterm]
endfunction

" Resolve the source theme's colors into [gui, cterm] pairs.
" 解析来源主题的颜色为 [gui, cterm] 对。
function! s:theme_pair(attr) abort
  let l:theme = get(g:, 'lightline#colorscheme#muted#theme', '')
  let l:c = s:read_theme_colors(l:theme)
  if a:attr ==# 'fg'
    return s:pair_from(l:c[0], l:c[2])
  else
    return s:pair_from(l:c[1], l:c[3])
  endif
endfunction

" Invert option: swap the chosen theme's foreground and background.
" 反转选项：交换所选主题的前景与背景。
let s:invert = get(g:, 'lightline#colorscheme#muted#invert', 0)

" Foreground: explicit override wins; otherwise the theme color (swapped by
" invert).  A NONE value is kept as-is so lightline inherits the terminal
" default foreground instead of being forced to a fixed color.
" 前景：显式覆盖优先；否则用主题颜色（invert 时交换）。NONE 保持原样，
" 让 lightline 继承终端默认前景，而不是被强制成固定颜色。
if get(g:, 'lightline#colorscheme#muted#fg', '') != ''
  let s:fg = s:resolve_pair('lightline#colorscheme#muted#fg', 'fg')
else
  let s:fg = s:invert ? s:theme_pair('bg') : s:theme_pair('fg')
endif

if get(g:, 'lightline#colorscheme#muted#bg', '') != ''
  let s:bg = s:resolve_pair('lightline#colorscheme#muted#bg', 'bg')
else
  let s:bg = s:invert ? s:theme_pair('fg') : s:theme_pair('bg')
endif

" A NONE theme (e.g. default with cleared Normal) has no real colors. Derive
" concrete colors from 'background' so inversion still works:
"   dark  : fg=#ffffff, bg=#000000
"   light : fg=#000000, bg=#ffffff
" NONE 主题（如 default，Normal 被清除）没有实际颜色。按 'background' 推导
" 具体颜色，使反转仍可工作：
"   dark  : fg=#ffffff, bg=#000000
"   light : fg=#000000, bg=#ffffff
let s:dark = &background !=# 'light'
let s:def_fg = s:dark ? [ '#ffffff', 15 ] : [ '#000000', 0 ]
let s:def_bg = s:dark ? [ '#000000', 0  ] : [ '#ffffff', 15 ]
let s:def_rev = [ s:def_bg, s:def_fg ]
let s:inherit = [ [ 'NONE', 'NONE' ], [ 'NONE', 'NONE' ] ]
let s:is_none = s:fg[0] ==# 'NONE' || s:bg[0] ==# 'NONE'

" ordinary: chunk used by all non-emphasis parts.
" emphasis: chunk used by mode (first left) and diagnostics.
" For a NONE theme, invert chooses which of them is filled with the derived
" colors; the other inherits. For a real theme they are fg/bg and swapped.
" ordinary：非强调部分使用的区块；emphasis：强调部分（mode 首块与诊断）。
" NONE 主题下由 invert 决定谁用推导色、谁继承；实色主题下为 fg/bg 与其交换。
if s:is_none
  let s:ordinary = s:invert ? s:def_rev : s:inherit
  let s:emphasis = s:invert ? s:inherit : s:def_rev
else
  let s:ordinary = [ s:fg, s:bg ]
  let s:emphasis = [ s:bg, s:fg ]
endif

" Build a chunk [ [fg_gui, fg_cterm], [bg_gui, bg_cterm] ] with independent
" copies so chunks never share list references.
" 构造区块 [ [前景gui, 前景cterm], [背景gui, 背景cterm] ]，使用独立副本，
" 避免区块之间共享列表引用。
function! s:chunk(template) abort
  return [ copy(a:template[0]), copy(a:template[1]) ]
endfunction

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

" Emphasis first left chunk (mode) + diagnostics; the rest is ordinary.
" 强调部分：normal/insert/replace/visual 的左侧第一区块（mode）与诊断信息；
" 其余为普通块。
let s:p.normal.left     = [ s:chunk(s:emphasis), s:chunk(s:ordinary) ]
let s:p.normal.middle   = [ s:chunk(s:ordinary) ]
let s:p.normal.right    = [ s:chunk(s:ordinary), s:chunk(s:ordinary) ]
let s:p.normal.error    = [ s:chunk(s:emphasis) ]
let s:p.normal.warning  = [ s:chunk(s:emphasis) ]

let s:p.insert.left     = [ s:chunk(s:emphasis), s:chunk(s:ordinary) ]
let s:p.insert.middle   = [ s:chunk(s:ordinary) ]
let s:p.insert.right    = [ s:chunk(s:ordinary), s:chunk(s:ordinary) ]

let s:p.replace.left    = [ s:chunk(s:emphasis), s:chunk(s:ordinary) ]
let s:p.replace.middle  = [ s:chunk(s:ordinary) ]
let s:p.replace.right   = [ s:chunk(s:ordinary), s:chunk(s:ordinary) ]

let s:p.visual.left     = [ s:chunk(s:emphasis), s:chunk(s:ordinary) ]
let s:p.visual.middle   = [ s:chunk(s:ordinary) ]
let s:p.visual.right    = [ s:chunk(s:ordinary), s:chunk(s:ordinary) ]

let s:p.inactive.left   = [ s:chunk(s:ordinary), s:chunk(s:ordinary) ]
let s:p.inactive.middle = [ s:chunk(s:ordinary) ]
let s:p.inactive.right  = [ s:chunk(s:ordinary), s:chunk(s:ordinary) ]

let s:p.tabline.left    = [ s:chunk(s:ordinary) ]
let s:p.tabline.middle  = [ s:chunk(s:ordinary) ]
let s:p.tabline.right   = [ s:chunk(s:ordinary) ]
let s:p.tabline.tabsel  = [ s:chunk(s:ordinary) ]

let g:lightline#colorscheme#muted#palette = lightline#colorscheme#flatten(s:p)
