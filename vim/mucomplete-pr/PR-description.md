# Fix `UltiSnips + Auto Pairs` example: snippets leave Insert mode

## Summary

The `UltiSnips + Auto Pairs` compatibility example currently chains
`<plug>AutoPairsReturn` *after* `<plug>UltiExpand`:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <plug>MyCR <plug>UltiExpand<plug>AutoPairsReturn
imap <cr> <plug>MyCR
```

Because `<plug>AutoPairsReturn` is a separate link in the mapping chain, it
runs **unconditionally** — including immediately after a `[snip]` entry has
been chosen from the pop-up menu and expanded.  `AutoPairsReturn()` uses
`<esc>`-based sequences internally (e.g. `"\<esc>O"`, `"\<esc>=ko"`), so
running it right after snippet expansion can leave Insert mode.  The snippet
is expanded but its placeholders can no longer be reached with the jump
trigger.

This is exactly what the current example produces on Vim 9.2 with
UltiSnips + auto-pairs.

## Reproduction

* Vim 9.2
* `vim-mucomplete`, `SirVer/ultisnips`, `jiangmiao/auto-pairs`
* `g:mucomplete#enable_auto_at_startup = 1`
* completion chain contains `'ulti'` (default)
* auto-pairs configured as in the current docs:

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

Steps:

1. Type a snippet trigger so that a `[snip]` entry appears in the pop-up.
2. Select it and press `<cr>`.

Observed: the snippet is expanded, but Vim ends up in Normal mode and the
UltiSnips jump trigger (e.g. `<c-j>`) no longer moves between placeholders.

## Fix

Move the fallback keys *inside* the argument of
`mucomplete#ultisnips#expand_snippet()`, instead of chaining them after
`<plug>UltiExpand`:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet(
      \     "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>UltiExpand
```

`expand_snippet()` uses its argument only when `pumvisible()` is false:

```vim
fun! mucomplete#ultisnips#expand_snippet(keys)
  return pumvisible()
        \ ? "\<c-y>\<c-r>=mucomplete#ultisnips#do_expand('')\<cr>"
        \ : a:keys
endf
```

So `<plug>AutoPairsReturn` now runs only for a plain `<cr>` outside
completion.  When a pop-up is visible the snippet (or ordinary completion)
path is taken and Auto Pairs is not involved.

## Changes

* `doc/mucomplete.txt`: rewrite the `UltiSnips + Auto Pairs` example, explain
  the wrong variant, and note that a plain `<cr>` in the fallback argument is
  returned directly by the expression mapping (putting it in a recursive
  `imap` chain would trigger `E223: Recursive mapping`).
* `test/test_mucomplete.vim`: add
  `Test_MU_ultisnips_expand_snippet_fallback_keys`, asserting that
  `expand_snippet()` returns its fallback argument unchanged when no pop-up
  is visible — the behaviour the corrected example relies on.

## Notes

* This matches how the `SnipMate + Auto Pairs` example already does it: it
  also executes `<plug>AutoPairsReturn` only in the non-pop-up branch.
* No functional/plugin code is changed; this is a documentation fix plus a
  regression test.
