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
"   - Transparent themes (Normal bg == NONE) stay transparent.
"   前景色：默认取当前配色主题 Normal 的前景色；
"           可通过 g:lightline#colorscheme#muted#fg 覆盖。
"   背景色：默认取当前配色主题 Normal 的背景色；
"           可通过 g:lightline#colorscheme#muted#bg 覆盖。
"   透明主题（Normal 背景为 NONE）保持透明。
"
" Accepted override formats (both fg and bg) / 可用覆盖格式（前景与背景通用）:
"   let g:lightline#colorscheme#muted#fg = '#D3C6AA'   " GUI hex / GUI 十六进制
"   let g:lightline#colorscheme#muted#fg = 'red'       " color name / 颜色名
"   let g:lightline#colorscheme#muted#fg = 187         " 256-color index / 256 色号
"   let g:lightline#colorscheme#muted#bg = 'NONE'      " transparent / 透明
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

let s:fg = s:resolve_pair('lightline#colorscheme#muted#fg', 'fg', '#D3C6AA')
let s:bg = s:resolve_pair('lightline#colorscheme#muted#bg', 'bg', '#14161b')

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
