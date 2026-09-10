# UltiSnips + Auto Pairs example leaves the just-expanded snippet

Hi, and thanks for MUcomplete!

I think the `UltiSnips + Auto Pairs` example in
`:help mucomplete-compatibility` has a subtle problem.  The example is:

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

Because `<plug>AutoPairsReturn` is a separate link in the mapping chain, it
runs unconditionally — including right after a `[snip]` item has been chosen
from the pop-up menu and expanded.  `AutoPairsReturn()` returns `<esc>`-based
sequences internally (e.g. `"\<esc>O"`), so it can leave Insert mode right
after the expansion.  The snippet is then expanded but no longer usable: the
UltiSnips jump trigger does not move between its placeholders.

Environment:

* Vim 9.2
* vim-mucomplete (current master)
* SirVer/ultisnips
* jiangmiao/auto-pairs
* `g:mucomplete#enable_auto_at_startup = 1`
* completion chain contains `'ulti'` (default)

Steps:

1. Type a snippet trigger so that a `[snip]` item appears in the pop-up.
2. Select it and press `<cr>`.

Observed: snippet expands, then Vim ends up in Normal mode; the jump trigger
does not work.
Expected: snippet expands and stays in Insert mode, ready for jumping between
placeholders.

Interestingly, the `SnipMate + Auto Pairs` example a few paragraphs above
already avoids this by putting `<plug>AutoPairsReturn` only in the
non-pop-up branch:

```vim
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<c-y>\<plug>snipMateTrigger"
    \ : "\<plug>MyEnter<plug>AutoPairsReturn")
```

Would you accept a change that applies the same pattern to the UltiSnips
example, i.e.:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

This keeps the existing `<plug>UltiExpand` helper, uses
`<plug>AutoPairsReturn` only outside completion, and mirrors the SnipMate
example.  I can prepare a small PR (docs + a regression test) if you think
this is the right direction.

Thanks!
