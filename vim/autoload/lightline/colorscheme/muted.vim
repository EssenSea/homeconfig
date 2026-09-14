" =============================================================================
" Filename:   autoload/lightline/colorscheme/muted.vim
" Purpose:    A deliberately "washed out" lightline palette.
" 用途：刻意做成“失色”效果的 lightline 调色板。
"
" Behavior / 行为:
"   - Foreground: defaults to the current colorscheme's Normal foreground.
"     Override with g:lightline#colorscheme#muted#fg.
"   - Background: always read from the current colorscheme's Normal background.
"   前景色：默认取当前配色主题 Normal 的前景色；
"           可通过 g:lightline#colorscheme#muted#fg 覆盖。
"   背景色：始终取当前配色主题 Normal 的背景色。
"
" Accepted override formats / 可用覆盖格式:
"   let g:lightline#colorscheme#muted#fg = '#D3C6AA'   " GUI hex / GUI 十六进制
"   let g:lightline#colorscheme#muted#fg = 'red'       " color name / 颜色名
"   let g:lightline#colorscheme#muted#fg = 187         " 256-color index / 256 色号
" =============================================================================

" Convert a 256-color index to an approximate '#RRGGBB'.
" lightline's fill() needs both fg and bg to be strings (or both numbers);
" since bg is always a hex string, we normalize the index to hex as well.
" 将 256 色号转为近似的 '#RRGGBB'。因为背景始终是十六进制字符串，
" 这里也把色号统一成字符串，交给 fill() 处理。
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

" Resolve the user override into a color string lightline can consume.
" 将用户覆盖值解析为 lightline 可用的颜色字符串。
function! s:resolve_fg() abort
  let l:val = get(g:, 'lightline#colorscheme#muted#fg', '')
  if type(l:val) == type(0)
    return s:nr_to_hex(l:val)
  elseif type(l:val) == type('') && !empty(l:val)
    if l:val =~# '^\d\+$'
      return s:nr_to_hex(str2nr(l:val))
    endif
    return l:val
  endif
  " Default: current Normal foreground.
  " 默认：当前 Normal 前景色。
  let l:gui = synIDattr(hlID('Normal'), 'fg#')
  return empty(l:gui) ? '#D3C6AA' : l:gui
endfunction

" Background: current Normal background.
" 背景色：当前 Normal 背景色。
function! s:bg() abort
  let l:gui = synIDattr(hlID('Normal'), 'bg#')
  if empty(l:gui) || l:gui ==# 'NONE'
    return '#14161b'
  endif
  return l:gui
endfunction

let s:fg = s:resolve_fg()
let s:bg = s:bg()

" Every entry is [ foreground, background ]; fill() expands the cterm values.
" 每一项是 [ 前景, 背景 ]，fill() 会自动补全 cterm 值。
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

let g:lightline#colorscheme#muted#palette = lightline#colorscheme#fill(s:p)
