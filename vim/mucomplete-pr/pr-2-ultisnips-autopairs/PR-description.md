# docs: keep UltiSnips snippets in Insert mode with Auto Pairs

## What happens

With the `UltiSnips + Auto Pairs` mapping from
`:help mucomplete-compatibility`, choosing a `[snip]` entry from the pop-up
and pressing `<cr>` expands the snippet, but Vim ends up in Normal mode and
the UltiSnips jump trigger no longer moves between placeholders.

`<plug>AutoPairsReturn` is chained after `<plug>UltiExpand`, so it also runs
right after the expansion; its `<esc>`-based return handling is what leaves
Insert mode.

## Fix

Use `<plug>AutoPairsReturn` only in the non-pop-up branch, the same shape the
`SnipMate + Auto Pairs` example already uses:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

## Changes

* `doc/mucomplete.txt`: update the `UltiSnips + Auto Pairs` example.
* `test/test_mucomplete.vim`: add a regression test asserting that
  `expand_snippet()` returns its fallback argument unchanged when no pop-up
  is visible.

## Notes

* No plugin code is changed.
* This makes the UltiSnips example consistent with `SnipMate + Auto Pairs`.
