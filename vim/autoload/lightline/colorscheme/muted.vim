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
"   - Foreground never stays transparent: if it somehow resolves to NONE it
"     falls back to the chosen theme's colors, then #D3C6AA.
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
"   前景不会保持透明：若仍解析为 NONE，则回退到所选主题的颜色，最后用
"   #D3C6AA。
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

function! s:resolve_pair(var, attr, fallback) abort
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

" True when a [gui, cterm] pair is fully transparent (both NONE).
" 当 [gui, cterm] 对完全透明（两者都是 NONE）时返回真。
function! s:is_none(pair) abort
  return a:pair[0] ==# 'NONE'
endfunction

" fg: explicit override wins; otherwise the (possibly inverted) theme color.
" If the resulting foreground would be transparent, fall back to the source
" theme's non-transparent color: its foreground when not inverted, its
" background when inverted (never leave lightline without a foreground).
" fg：显式覆盖优先；否则用（可能反转后的）主题颜色。
" 若最终前景会变成透明，则回退到来源主题的非透明颜色：未反转时取前景，
" 反转时取背景（绝不把前景留成空）。
" bg: explicit override wins; otherwise the (possibly inverted) theme color.
" bg：显式覆盖优先；否则用（可能反转后的）主题颜色。
let s:invert = get(g:, 'lightline#colorscheme#muted#invert', 0)

if get(g:, 'lightline#colorscheme#muted#fg', '') != ''
  let s:fg = s:resolve_pair('lightline#colorscheme#muted#fg', 'fg', '#D3C6AA')
else
  let s:fg = s:invert ? s:theme_pair('bg') : s:theme_pair('fg')
endif
" Foreground transparency fallback. / 前景透明回退。
" Order: preferred side (by invert), then the other side, then a default.
" 顺序：按 invert 首选的一侧，然后另一侧，最后默认色。
if s:is_none(s:fg)
  let s:fg = s:invert ? s:theme_pair('bg') : s:theme_pair('fg')
  if s:is_none(s:fg)
    let s:fg = s:invert ? s:theme_pair('fg') : s:theme_pair('bg')
  endif
  if s:is_none(s:fg)
    let s:fg = ['#D3C6AA', 187]
  endif
endif

if get(g:, 'lightline#colorscheme#muted#bg', '') != ''
  let s:bg = s:resolve_pair('lightline#colorscheme#muted#bg', 'bg', '#14161b')
else
  let s:bg = s:invert ? s:theme_pair('fg') : s:theme_pair('bg')
endif

" Every entry is [ [fg_gui, fg_cterm], [bg_gui, bg_cterm] ]; flatten() turns
" it into the form lightline expects, and keeps 'NONE' for transparency.
" 每一项是 [ [前景gui, 前景cterm], [背景gui, 背景cterm] ]；flatten() 会
" 转成 lightline 需要的格式，并保留 'NONE' 以实现透明。
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left     = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.normal.middle   = [ [ s:fg, s:bg ] ]
let s:p.normal.right    = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.normal.error    = [ [ s:fg, s:bg ] ]
let s:p.normal.warning  = [ [ s:fg, s:bg ] ]

let s:p.insert.left     = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.insert.middle   = [ [ s:fg, s:bg ] ]
let s:p.insert.right    = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.replace.left    = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.replace.middle  = [ [ s:fg, s:bg ] ]
let s:p.replace.right   = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.visual.left     = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.visual.middle   = [ [ s:fg, s:bg ] ]
let s:p.visual.right    = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.inactive.left   = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]
let s:p.inactive.middle = [ [ s:fg, s:bg ] ]
let s:p.inactive.right  = [ [ s:fg, s:bg ], [ s:fg, s:bg ] ]

let s:p.tabline.left    = [ [ s:fg, s:bg ] ]
let s:p.tabline.middle  = [ [ s:fg, s:bg ] ]
let s:p.tabline.right   = [ [ s:fg, s:bg ] ]
let s:p.tabline.tabsel  = [ [ s:fg, s:bg ] ]

let g:lightline#colorscheme#muted#palette = lightline#colorscheme#flatten(s:p)
