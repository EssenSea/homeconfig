# docs: use the same shape as SnipMate + Auto Pairs for UltiSnips

## What the help already says

The `SnipMate + Auto Pairs` example in `mucomplete-compatibility` already
puts `<plug>AutoPairsReturn` in the non-pop-up branch:

```vim
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<c-y>\<plug>snipMateTrigger"
    \ : "\<plug>MyEnter<plug>AutoPairsReturn")
```

The `UltiSnips + Auto Pairs` example just above it chains
`<plug>AutoPairsReturn` after `<plug>UltiExpand` instead:

```vim
imap <plug>MyCR <plug>UltiExpand<plug>AutoPairsReturn
imap <cr> <plug>MyCR
```

## What is different

The two examples use two different shapes for the same job.  The UltiSnips
one also runs `<plug>AutoPairsReturn` right after a `[snip]` entry has been
expanded; its `<esc>`-based return handling can then leave Insert mode and
the UltiSnips jump trigger stops working.

## Fix

Use the same shape as the SnipMate example, so `<plug>AutoPairsReturn` only
runs outside completion:

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
* This makes the two snippet + Auto Pairs examples consistent.
