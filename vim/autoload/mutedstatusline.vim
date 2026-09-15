" =============================================================================
" Filename:   autoload/mutedstatusline.vim
" Purpose:    Native Vim statusline built on the mutedstatus color backend.
"             Content is produced by component functions and assembled with
"             %#group# segments; colors are refreshed on relevant events.
" 用途：基于 mutedstatus 取色后端的原生 Vim statusline。内容由组件函数产生，
"       通过 %#高亮组# 分段拼装；颜色在相关事件时刷新。
"
" Enable with / 启用方式:
"   set statusline=%!mutedstatusline#string()
"   call mutedstatusline#setup()
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" --- component content (pure text, no colors) ------------------------------
" --- 组件内容（纯文本，不含颜色）------------------------------------------
let s:mode_map = {
      \ 'n'      : 'NORMAL',
      \ 'i'      : 'INSERT',
      \ 'R'      : 'REPLACE',
      \ 'v'      : 'VISUAL',
      \ 'V'      : 'V-LINE',
      \ "\<C-v>" : 'V-BLOCK',
      \ 'c'      : 'COMMAND',
      \ 's'      : 'SELECT',
      \ 'S'      : 'S-LINE',
      \ "\<C-s>" : 'S-BLOCK',
      \ 't'      : 'TERMINAL',
      \ }

function! mutedstatusline#mode() abort
  return get(s:mode_map, mode(), mode())
endfunction

function! mutedstatusline#paste() abort
  return &paste ? 'PASTE' : ''
endfunction

function! mutedstatusline#readonly() abort
  return &readonly ? 'RO' : ''
endfunction

function! mutedstatusline#modified() abort
  return &modified ? '+' : (&modifiable ? '' : '-')
endfunction

function! mutedstatusline#filename() abort
  let l:name = expand('%:t')
  return empty(l:name) ? '[No Name]' : l:name
endfunction

" ALE diagnostics (empty when ALE is unavailable). / ALE 诊断（不可用时为空）。
function! s:ale_count(kind) abort
  if !exists('*ale#statusline#Count')
    return 0
  endif
  let l:c = ale#statusline#Count(bufnr(''))
  if a:kind ==# 'error'
    return l:c.error + l:c.style_error
  else
    return l:c.warning + l:c.style_warning
  endif
endfunction

function! mutedstatusline#ale_errors() abort
  let l:n = s:ale_count('error')
  return l:n ? printf('E:%d', l:n) : ''
endfunction

function! mutedstatusline#ale_warnings() abort
  let l:n = s:ale_count('warning')
  return l:n ? printf('W:%d', l:n) : ''
endfunction

" --- assemble the statusline string ----------------------------------------
" --- 组装 statusline 字符串 -------------------------------------------------
" Uses the highlight groups defined by mutedstatus#apply_default():
"   MutedStatusMode / MutedStatusFile / MutedStatusRight /
"   MutedStatusError / MutedStatusWarning
" 使用 mutedstatus#apply_default() 定义的高亮组。
function! mutedstatusline#string() abort
  let l:s = ''
  " mode chunk (emphasis) / 模式区块（强调）
  let l:s .= '%#MutedStatusMode# ' . '%{mutedstatusline#mode()}'
  let l:s .= '%{mutedstatusline#paste()}'
  " file chunk (ordinary) / 文件区块（普通）
  let l:s .= '%#MutedStatusFile# '
  let l:s .= '%( ' . '%{mutedstatusline#filename()}' . ' %)'
  let l:s .= '%{mutedstatusline#modified()}%{mutedstatusline#readonly()}'
  " diagnostics (emphasis) / 诊断（强调）
  let l:s .= '%#MutedStatusError#%{mutedstatusline#ale_errors()}'
  let l:s .= '%#MutedStatusWarning#%{mutedstatusline#ale_warnings()}'
  " right side / 右侧
  let l:s .= '%#MutedStatusRight#%=' . ' %l:%c  %P '
  return l:s
endfunction

" --- color refresh ----------------------------------------------------------
" --- 颜色刷新 ---------------------------------------------------------------
" Content refreshes automatically; highlight groups are static and must be
" recomputed when the theme, 'background' or mode changes.
" 内容会自动刷新；高亮组是静态的，需在主题/background/模式变化时重算。
function! mutedstatusline#refresh() abort
  call mutedstatus#apply_default()
  redrawstatus
endfunction

" Install the statusline and the refresh autocmds.
" 安装 statusline 与刷新自动命令。
function! mutedstatusline#setup() abort
  call mutedstatusline#refresh()
  set statusline=%!mutedstatusline#string()
  augroup mutedstatusline
    autocmd!
    autocmd ModeChanged,ColorScheme,WinEnter,BufEnter * call mutedstatusline#refresh()
    autocmd User ALELint,ALEIndexInvalidate redrawstatus
  augroup END
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
