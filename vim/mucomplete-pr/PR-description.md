# UltiSnips + Auto Pairs example: keep snippets in Insert mode

## What happens

With Vim 9.2, UltiSnips, auto-pairs and the `UltiSnips + Auto Pairs` mapping
from `:help mucomplete-compatibility`, choosing a `[snip]` entry from the
pop-up and pressing `<cr>` expands the snippet but leaves Vim in Normal mode.
The UltiSnips jump trigger then no longer moves between placeholders.

The documented mapping is:

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

## Suggested change

Use a `pumvisible()` branch, as the `SnipMate + Auto Pairs` example already
does, so `<plug>AutoPairsReturn` is only used outside completion:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

With this, a plain `<cr>` still gets auto-pairs' bracket-return behaviour,
while accepting a snippet keeps you in Insert mode.

## Changes

* `doc/mucomplete.txt`: update the `UltiSnips + Auto Pairs` example and
  mention the alternate (previous) form, so it is easy to compare.
* `test/test_mucomplete.vim`: add a small test asserting that
  `expand_snippet()` returns its fallback argument unchanged when no pop-up
  is visible, which is what the corrected example relies on.

## Notes

* No plugin code is changed; this is a documentation fix plus a test.
* This keeps the two compatibility examples (`SnipMate + Auto Pairs` and
  `UltiSnips + Auto Pairs`) consistent.
* Happy to adjust the style if you prefer something else.
