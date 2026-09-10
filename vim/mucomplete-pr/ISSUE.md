# UltiSnips + Auto Pairs example may be misleading next to SnipMate + Auto Pairs

Hi, and thanks for MUcomplete!

In `:help mucomplete-compatibility` the two "snippet + Auto Pairs" examples
use two different shapes.

The `SnipMate + Auto Pairs` example puts `<plug>AutoPairsReturn` in the
non-pop-up branch:

    imap <silent> <expr> <plug>MyCR (pumvisible()
        \ ? "<c-y><plug>snipMateTrigger"
        \ : "<plug>MyEnter<plug>AutoPairsReturn")

The `UltiSnips + Auto Pairs` example a few paragraphs later chains
`<plug>AutoPairsReturn` after `<plug>UltiExpand` instead:

    imap <plug>MyCR <plug>UltiExpand<plug>AutoPairsReturn
    imap <cr> <plug>MyCR

With the second shape on Vim 9.2, choosing a `[snip]` entry from the pop-up
and pressing `<cr>` expands the snippet but leaves Insert mode, so the
UltiSnips jump trigger no longer moves between placeholders.

Since the two examples sit next to each other and do the same kind of job,
readers may reasonably assume both shapes are equivalent. Would it make sense
to use the SnipMate shape for the UltiSnips example too, e.g.:

    inoremap <silent> <expr> <plug>UltiExpand
          \ mucomplete#ultisnips#expand_snippet("\<cr>")
    imap <silent> <expr> <plug>MyCR (pumvisible()
        \ ? "<plug>UltiExpand"
        \ : "<cr>\<plug>AutoPairsReturn")
    imap <cr> <plug>MyCR

I can send a small docs patch if you think it is worth it.
