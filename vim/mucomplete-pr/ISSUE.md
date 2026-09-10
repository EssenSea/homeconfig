# Three small documentation inconsistencies around MUcomplete

Hi, and thanks for MUcomplete!

I use Vim 9.2 with UltiSnips and auto-pairs. I read the relevant help
sections and found three places where the docs already say something, but
either contradict themselves or only cover part of the picture. I have
listed what the help already says, and what I think is different. Three
small, independent patches follow; happy to send them separately.

## 1. `UltiSnips + Auto Pairs` uses a different shape than `SnipMate + Auto Pairs`

What the help already says:

* the `SnipMate + Auto Pairs` example (in `mucomplete-compatibility`) puts
  `<plug>AutoPairsReturn` in the non-pop-up branch:
  ```vim
  imap <silent> <expr> <plug>MyCR (pumvisible()
      \ ? "\<c-y>\<plug>snipMateTrigger"
      \ : "\<plug>MyEnter<plug>AutoPairsReturn")
  ```
* the `UltiSnips + Auto Pairs` example just above it chains
  `<plug>AutoPairsReturn` after `<plug>UltiExpand`:
  ```vim
  imap <plug>MyCR <plug>UltiExpand<plug>AutoPairsReturn
  imap <cr> <plug>MyCR
  ```

What is different: the two examples use two different shapes for the same
job, and the UltiSnips one runs `<plug>AutoPairsReturn` after a `[snip]`
entry has been expanded as well. In my case that leaves Insert mode and the
UltiSnips jump trigger stops working.

### Fix

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

## 2. `<Plug>(MUcompleteCR)` literal: the version note exists, the effect does not

What the help already says:

* `mucomplete-plugs` lists the pop-up plugs as "defined only in Vim 8.0.0282
  or older";
* `g:mucomplete#no_popup_mappings` says the same, and there is a
  Vim-8.0.0283+ `<cr>` mapping in `mucomplete-tips`.

What is different: none of these say what actually happens on a current Vim
when an expression mapping returns one of those plugs, i.e. that the plug
name is inserted as literal text. I only understood this after seeing the
literal `<Plug>(MUcompleteCR)` appended to my completed text.

### Fix

Add one sentence to the plug list, e.g. that an expression mapping returning
one of these plugs on Vim 8.0.0283 or later inserts the plug name as literal
text, and point to the supported `<cr>` mapping in `mucomplete-tips`.

## 3. Load-time options: one is documented, the rest are not

What the help already says:

* `g:mucomplete#user_mappings` already notes it "is read only once when
  MUcomplete is loaded" and suggests `mucomplete#add_user_mapping()` for
  later definitions.

What is different: the same is true for

* `g:mucomplete#no_mappings`
* `g:mucomplete#enable_auto_at_startup`
* `g:mucomplete#chains`
* `g:mucomplete#spel#regex`
* `g:mucomplete#use_only_windows_paths`

but none of them say so, even though they are documented next to options that
are read on demand and can be changed at any time. It is easy to assume they
all behave the same way.

### Fix

Add a short paragraph at the top of `:help mucomplete-customization` listing
the options that are read once at load time and must be set before MUcomplete
is loaded, note that the remaining options are read at runtime, and add a
short note under each of the five options above (mirroring the existing
`user_mappings` note).
