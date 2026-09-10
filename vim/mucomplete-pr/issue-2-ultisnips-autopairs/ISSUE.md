# UltiSnips + Auto Pairs example and the jump trigger

Hi, and thanks for MUcomplete!

With the `UltiSnips + Auto Pairs` example from
`:help mucomplete-compatibility`, choosing a `[snip]` entry from the pop-up
and pressing `<cr>` expands the snippet, but Vim ends up in Normal mode, so
the UltiSnips jump trigger no longer moves between placeholders.

### Fix

Put `<plug>AutoPairsReturn` only in the non-pop-up branch, the same shape the
`SnipMate + Auto Pairs` example above already uses:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

I can send a docs patch (plus a small test).
