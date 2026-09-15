" =============================================================================
" Filename:   autoload/mutedstatus.vim
" Purpose:    Native statusline color backend using the same "muted" color
"             logic as the lightline muted palette, but independent of
"             lightline.  Provides foreground/background pairs (ordinary and
"             emphasis) and helpers to apply them to highlight groups.
" 用途：原生 statusline 的取色后端，复用与 lightline muted 调色板相同的
"       “失色”取色逻辑，但不依赖 lightline。它产出普通/强调两种 [fg,bg]
"       区块色，并提供把颜色应用到高亮组的辅助函数。
"
" Options (fall back to the lightline ones) / 选项（回退到 lightline 的变量）:
"   g:mutedstatus#theme  | g:lightline#colorscheme#muted#theme
"   g:mutedstatus#invert | g:lightline#colorscheme#muted#invert
"   g:mutedstatus#fg     | g:lightline#colorscheme#muted#fg
"   g:mutedstatus#bg     | g:lightline#colorscheme#muted#bg
"
" Accepted formats / 可用格式:
"   '#RRGGBB', color name, 256-color index, 'NONE'
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" --- option lookup (mutedstatus# first, then lightline muted) --------------
" --- 选项查询（优先 mutedstatus#，其次 lightline muted）--------------------
" Return the actual g: variable name that holds a given option, preferring
" the mutedstatus# namespace over the lightline one; '' if neither is set.
" 返回实际存在该选项的 g: 变量名，优先 mutedstatus#，其次 lightline；都没有
" 则返回空串。
function! s:opt_var(name) abort
  let l:a = 'mutedstatus#' . a:name
  if exists('g:' . l:a)
    return l:a
  endif
  let l:b = 'lightline#colorscheme#muted#' . a:name
  if exists('g:' . l:b)
    return l:b
  endif
  return ''
endfunction

function! s:opt(name, default) abort
  let l:key = 'mutedstatus#' . a:name
  if exists('g:' . l:key)
    return get(g:, l:key)
  endif
  let l:key2 = 'lightline#colorscheme#muted#' . a:name
  if exists('g:' . l:key2)
    return get(g:, l:key2)
  endif
  return a:default
endfunction

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
    " Ask Vim to resolve a color name to '#RRGGBB'.
    " 让 Vim 把颜色名解析为 '#RRGGBB'。
    silent! execute 'highlight _MutedStatusProbe guifg=' . a:color
    let l:hex = synIDattr(hlID('_MutedStatusProbe'), 'fg#')
    silent! highlight clear _MutedStatusProbe
    if !empty(l:hex) && l:hex =~# '^#'
      let l:rgb = matchlist(l:hex, '#\(..\)\(..\)\(..\)')
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
      silent! execute 'highlight _MutedStatusProbe guifg=' . l:val
      let l:hex = synIDattr(hlID('_MutedStatusProbe'), 'fg#')
      silent! highlight clear _MutedStatusProbe
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

" --- Read a named theme's opaque Normal fg/bg ------------------------------
" --- 读取指定主题非透明的 Normal 前景/背景 ---------------------------------
let s:transparent_opts = [
      \ 'everforest_transparent_background',
      \ 'catppuccin_transparent_background',
      \ 'iceberg_transparent_background',
      \ 'tokyonight_transparent_background',
      \ ]

function! s:read_theme_colors(theme) abort
  let l:orig = get(g:, 'colors_name', '')
  let l:switched = 0
  let l:orig_bg_opt = &background
  let l:saved = {}
  for l:var in s:transparent_opts
    if exists('g:' . l:var)
      let l:saved[l:var] = get(g:, l:var, 0)
      execute 'let g:' . l:var . ' = 0'
    endif
  endfor
  if !empty(a:theme)
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
  if l:switched && !empty(l:orig)
    silent! noautocmd execute 'colorscheme ' . l:orig
  endif
  let &background = l:orig_bg_opt
  for [l:var, l:val] in items(l:saved)
    execute 'let g:' . l:var . ' = ' . l:val
  endfor
  return [l:fg_gui, l:bg_gui, l:fg_cterm, l:bg_cterm]
endfunction

function! s:pair_from(gui, cterm) abort
  if empty(a:gui) || a:gui ==# 'NONE'
    return ['NONE', empty(a:cterm) ? 'NONE' : a:cterm]
  endif
  return [a:gui, empty(a:cterm) ? s:gui_to_cterm(a:gui) : a:cterm]
endfunction

function! s:theme_pair(attr) abort
  let l:theme = s:opt('theme', '')
  let l:c = s:read_theme_colors(l:theme)
  if a:attr ==# 'fg'
    return s:pair_from(l:c[0], l:c[2])
  else
    return s:pair_from(l:c[1], l:c[3])
  endif
endfunction

" --- Public API -----------------------------------------------------------
" --- 公共接口 --------------------------------------------------------------

" Return the resolved muted colors as a dictionary with two chunk templates:
"   {'ordinary': [fg_pair, bg_pair], 'emphasis': [fg_pair, bg_pair],
"    'fg': fg_pair, 'bg': bg_pair, 'invert': 0/1, 'is_none': 0/1}
" 返回解析后的 muted 颜色，含两个区块模板（ordinary/emphasis）及辅助字段。
function! mutedstatus#colors() abort
  let l:invert = s:opt('invert', 0)
  let l:fg_var = s:opt_var('fg')
  let l:bg_var = s:opt_var('bg')

  if !empty(l:fg_var) && get(g:, l:fg_var, '') != ''
    let s:fg = s:resolve_pair(l:fg_var, 'fg')
  else
    let s:fg = l:invert ? s:theme_pair('bg') : s:theme_pair('fg')
  endif

  if !empty(l:bg_var) && get(g:, l:bg_var, '') != ''
    let s:bg = s:resolve_pair(l:bg_var, 'bg')
  else
    let s:bg = l:invert ? s:theme_pair('fg') : s:theme_pair('bg')
  endif

  let l:dark = &background !=# 'light'
  let l:def_fg = l:dark ? [ '#ffffff', 15 ] : [ '#000000', 0 ]
  let l:def_bg = l:dark ? [ '#000000', 0 ] : [ '#ffffff', 15 ]
  let l:def_rev = [ l:def_bg, l:def_fg ]
  let l:inherit = [ [ 'NONE', 'NONE' ], [ 'NONE', 'NONE' ] ]
  let l:is_none = s:fg[0] ==# 'NONE' || s:bg[0] ==# 'NONE'

  if l:is_none
    let l:ordinary = l:invert ? l:def_rev : l:inherit
    let l:emphasis = l:invert ? l:inherit : l:def_rev
  else
    let l:ordinary = [ s:fg, s:bg ]
    let l:emphasis = [ s:bg, s:fg ]
  endif

  return {
        \ 'ordinary' : l:ordinary,
        \ 'emphasis' : l:emphasis,
        \ 'fg'       : s:fg,
        \ 'bg'       : s:bg,
        \ 'invert'   : l:invert,
        \ 'is_none'  : l:is_none,
        \ }
endfunction

" Apply one [fg_pair, bg_pair] chunk to a highlight group.
" 把一个 [前景对, 背景对] 区块应用到某个高亮组。
function! mutedstatus#hi(group, chunk) abort
  let l:fg = a:chunk[0]
  let l:bg = a:chunk[1]
  let l:cmd = 'highlight ' . a:group
        \ . ' guifg=' . l:fg[0] . ' guibg=' . l:bg[0]
        \ . ' ctermfg=' . l:fg[1] . ' ctermbg=' . l:bg[1]
  execute l:cmd
endfunction

" Apply a dict of {group_name: 'ordinary'|'emphasis'} using the muted colors.
" 用 muted 颜色把 {组名: 'ordinary'|'emphasis'} 应用出去。
function! mutedstatus#apply(groups) abort
  let l:c = mutedstatus#colors()
  for [l:group, l:kind] in items(a:groups)
    let l:chunk = get(l:c, l:kind, l:c.ordinary)
    call mutedstatus#hi(l:group, l:chunk)
  endfor
endfunction

" Convenience: apply the default muted statusline group scheme.
" 便捷：应用默认的 muted statusline 高亮组方案。
function! mutedstatus#apply_default() abort
  call mutedstatus#apply({
        \ 'MutedStatusMode'       : 'emphasis',
        \ 'MutedStatusFile'       : 'ordinary',
        \ 'MutedStatusRight'      : 'ordinary',
        \ 'MutedStatusError'      : 'emphasis',
        \ 'MutedStatusWarning'    : 'emphasis',
        \ 'MutedStatusInactive'   : 'ordinary',
        \ })
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
