# UltiSnips + Auto Pairs example and `<Plug>(MUcompleteCR)`

Hi, and thanks for MUcomplete!

I use Vim 9.2 with UltiSnips and auto-pairs. Two things I ran into, with
what I think the docs should say instead.

## 1. `<Plug>(MUcompleteCR)` is only defined on old Vim

Following the pop-up-mapping examples, I had this in my vimrc:

```vim
function! CompleteCR()
  if pumvisible()
    return "\<Plug>(MUcompleteCR)"
  endif
  return "\<CR>"
endfunction
inoremap <silent> <expr> <CR> CompleteCR()
```

On my Vim, `<Plug>(MUcompleteCR)` is not defined: it only exists in Vim
8.0.0282 and earlier, per `:help mucomplete-plugs`. An expression mapping
that returns an undefined `<Plug>` inserts it as literal text, so after
confirming a completion the characters `<Plug>(MUcompleteCR)` were appended
to the inserted text.

### Fix

On Vim 8.0.0283 and later the pop-up mappings are not defined, and the
supported form is simply:

```vim
inoremap <expr> <cr> pumvisible() ? "<c-y><cr>" : "<cr>"
```

The docs already give this in `mucomplete-tips` (the "does not always insert
a new line" question). The fix is to make the older-Vim examples that use
`<Plug>(MUcompleteCR)` refer to that form, or to mark them more explicitly,
so a current-Vim user does not copy a plug that no longer exists.

## 2. `UltiSnips + Auto Pairs`: snippet leaves Insert mode

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

choosing a `[snip]` entry from the pop-up and pressing `<cr>` expands the
snippet, but Vim ends up in Normal mode and the jump trigger no longer moves
between placeholders. `<plug>AutoPairsReturn` is chained after
`<plug>UltiExpand`, so it also runs right after the expansion; its
`<esc>`-based return handling is what leaves Insert mode.

### Fix

Put `<plug>AutoPairsReturn` only in the non-pop-up branch, the same shape the
`SnipMate + Auto Pairs` example already uses:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

A plain `<cr>` still gets auto-pairs' bracket-return behaviour, while
accepting a snippet stays in Insert mode.

I can send a docs patch for either or both.
