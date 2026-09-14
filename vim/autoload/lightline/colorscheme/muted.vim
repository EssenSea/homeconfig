" =============================================================================
" Filename:   autoload/lightline/colorscheme/muted.vim
" Purpose:    A deliberately "washed out" lightline palette.
" 用途：刻意做成“失色”效果的 lightline 调色板。
"
" - All foreground text uses a single muted color: #D3C6AA
" - All backgrounds are read from the current colorscheme's Normal background
"   所有前景文字统一使用 #D3C6AA；
"   所有背景色动态读取当前配色主题 Normal 的背景色。
" =============================================================================

" Foreground / 前景色
let s:fg = [ '#D3C6AA', 187 ]

" Read current Normal background; fall back to a dark default.
" 读取当前 Normal 背景色；若不可用则回退到深色默认值。
function! s:bg() abort
  let l:gui = synIDattr(hlID('Normal'), 'bg#')
  let l:cterm = synIDattr(hlID('Normal'), 'bg', 'cterm')
  if empty(l:gui) || l:gui ==# 'NONE'
    let l:gui = '#14161b'
  endif
  if empty(l:cterm)
    let l:cterm = 233
  endif
  return [ l:gui, str2nr(l:cterm) ]
endfunction

let s:bg = s:bg()

" Every entry is [ foreground, background ].
" 每一项都是 [ 前景, 背景 ]。
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

" Use the same unified foreground/background everywhere; only the "middle"
" and inactive parts get the background as well so the whole bar is muted.
" 所有模式统一使用同一前景/背景；中间与无活动部分也用背景色，使整条状态栏失色。
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
