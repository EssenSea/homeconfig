# Fix UltiSnips + Auto Pairs example: keep snippets in Insert mode

## Summary

`doc/mucomplete.txt` currently documents the `UltiSnips + Auto Pairs`
combination as:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <plug>MyCR <plug>UltiExpand<plug>AutoPairsReturn
imap <cr> <plug>MyCR
```

`<plug>AutoPairsReturn` is chained after `<plug>UltiExpand`, so it runs
unconditionally — including right after a `[snip]` item has been expanded
from the pop-up.  `AutoPairsReturn()` returns `<esc>`-based sequences (e.g.
`"\<esc>O"`, `"\<esc>=ko"`) when the cursor is inside a bracket pair, so it
can leave Insert mode immediately after the expansion.  The snippet is
expanded but unusable: the UltiSnips jump trigger no longer moves between
placeholders.

## Reproduction

* Vim 9.2
* `vim-mucomplete` current master
* `SirVer/ultisnips`, `jiangmiao/auto-pairs`
* `g:mucomplete#enable_auto_at_startup = 1`
* default completion chain (contains `'ulti'`)

With the mapping shown above:

1. type a snippet trigger so a `[snip]` entry appears in the pop-up;
2. select it and press `<cr>`.

Result: the snippet expands, then Vim ends up in Normal mode.

## Fix

Use `<plug>AutoPairsReturn` only in the non-pop-up branch, mirroring the
existing `SnipMate + Auto Pairs` example:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

* when the pop-up is visible, the snippet/completion path runs and Auto Pairs
  is not involved;
* otherwise, a plain `<cr>` is emitted first, then
  `<plug>AutoPairsReturn` restores auto-pairs' bracket-return behaviour.

The `<cr>` in the fallback is returned by an expression mapping, so it is not
re-mapped; putting the fallback into a recursive `imap` chain that expands to
another `<cr>` would raise `E223: Recursive mapping`.

## Changes

* `doc/mucomplete.txt`: update the `UltiSnips + Auto Pairs` example and
  explain the failure mode of the previous form.  No other docs touched.
* `test/test_mucomplete.vim`: add
  `Test_MU_ultisnips_expand_snippet_fallback_keys`, asserting that
  `expand_snippet()` returns its fallback argument unchanged when
  `pumvisible()` is false — the property the corrected example relies on.

## Notes

* No plugin code is changed; this is a documentation fix plus a regression
  test.
* The change makes the UltiSnips example consistent with the
  `SnipMate + Auto Pairs` example already in the same help file.
* Happy to switch the example to an explicit `mucomplete#ultisnips#do_expand()`
  form if you prefer that style.
