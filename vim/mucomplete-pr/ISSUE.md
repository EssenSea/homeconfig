# UltiSnips + Auto Pairs example and snippet jump trigger

Hi, and thanks for MUcomplete!

I tried the `UltiSnips + Auto Pairs` snippet from
`:help mucomplete-compatibility` with Vim 9.2, UltiSnips and auto-pairs.
When I pick a `[snip]` entry from the pop-up and press `<cr>`, the snippet
is expanded, but Vim ends up in Normal mode, so the UltiSnips jump trigger
no longer moves between placeholders.

This is with:

* Vim 9.2
* `g:mucomplete#enable_auto_at_startup = 1`
* the default chain (which includes `'ulti'`)

and the documented mapping:

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

I noticed the `SnipMate + Auto Pairs` example above uses a
`pumvisible()` branch and works fine for me. Would it be OK to use the
same shape for the UltiSnips example, for example:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

I can prepare a small docs patch if that direction sounds reasonable.

Thanks!
