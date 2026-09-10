# UltiSnips + Auto Pairs example and snippet jump trigger

Hi, and thanks for MUcomplete!

I use Vim 9.2 with UltiSnips, auto-pairs and the `UltiSnips + Auto Pairs`
mapping from `:help mucomplete-compatibility`. I have run into two things
and would be happy to send small docs patches for either.

## 1. Plain `<cr>` with `<Plug>(MUcompleteCR)`

Following the older pop-up-mapping examples, I had this in my vimrc:

```vim
function! CompleteCR()
  if pumvisible()
    return "\<Plug>(MUcompleteCR)"
  endif
  return "\<CR>"
endfunction
inoremap <silent> <expr> <CR> CompleteCR()
```

On my Vim, `<Plug>(MUcompleteCR)` is not defined (it only exists in Vim
8.0.0282 and earlier, per `:help mucomplete-plugs`), so the expression
mapping inserts the text literally: after confirming a completion, the
literal characters `<Plug>(MUcompleteCR)` are appended at the end of the
inserted text. It took me a while to notice it was not a completion
artifact but the plug name as text.

I understand such examples are marked for older Vim, but since the plug is
listed in `:help mucomplete-plugs` alongside the pop-up ones, it may be
easy to copy without noticing the version note.

## 2. Snippet expansion and the jump trigger

With the `UltiSnips + Auto Pairs` example:

```vim
let g:AutoPairsMapCR = 0
let g:AutoPairsMapSpace = 0
imap <silent> <expr> <space> pumvisible()
  \ ? "<space>"
  \ : "<c-r>=AutoPairsSpace()<cr>"

inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <plug>MyCR <plug>UltiExpand<plug>AutoPairsReturn
imap <cr> <plug>MyCR
```

picking a `[snip]` entry from the pop-up and pressing `<cr>` expands the
snippet, but Vim ends up in Normal mode, so the UltiSnips jump trigger no
longer moves between placeholders.

The `SnipMate + Auto Pairs` example above uses a `pumvisible()` branch and
works fine for me. Would it be OK to use the same shape for the UltiSnips
example, for example:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

I can prepare small docs patches for either or both, if that sounds
reasonable. Thanks!
