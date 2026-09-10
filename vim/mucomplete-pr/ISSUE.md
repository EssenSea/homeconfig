# Three documentation issues around MUcomplete and UltiSnips / auto-pairs

Hi, and thanks for MUcomplete!

I use Vim 9.2 with UltiSnips and auto-pairs, and ran into three
documentation issues. Each one is small and independent; I can send a
separate patch for each if that is easier to review.

## 1. `<Plug>(MUcompleteCR)` is inserted as literal text on current Vim

Following the old pop-up-mapping examples, I had this in my vimrc:

```vim
function! CompleteCR()
  if pumvisible()
    return "\<Plug>(MUcompleteCR)"
  endif
  return "\<CR>"
endfunction
inoremap <silent> <expr> <CR> CompleteCR()
```

`<Plug>(MUcompleteCR)` is only defined for Vim 8.0.0282 and older. On my
Vim it is not defined, so the expression mapping inserts the plug name as
literal text: after confirming a completion, the characters
`<Plug>(MUcompleteCR)` are appended to the inserted text.

### Fix

On Vim 8.0.0283 and later the supported form is:

```vim
inoremap <expr> <cr> pumvisible() ? "<c-y><cr>" : "<cr>"
```

The help already gives this in `mucomplete-tips`, but the plug list in
`mucomplete-plugs` does not mention that an undefined plug ends up as
literal text. Adding a short warning there is enough.

## 2. `UltiSnips + Auto Pairs`: the snippet leaves Insert mode

With the `UltiSnips + Auto Pairs` example, choosing a `[snip]` entry from the
pop-up and pressing `<cr>` expands the snippet, but Vim ends up in Normal
mode and the jump trigger no longer moves between placeholders.

`<plug>AutoPairsReturn` is chained after `<plug>UltiExpand`, so it also runs
right after the expansion; its `<esc>`-based return handling is what leaves
Insert mode.

### Fix

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

## 3. Options read once at load time are not marked

These options are read once, when the plugin is loaded, so setting them later
has no effect:

* `g:mucomplete#no_mappings`
* `g:mucomplete#enable_auto_at_startup`
* `g:mucomplete#chains`
* `g:mucomplete#spel#regex`
* `g:mucomplete#use_only_windows_paths`
* `g:mucomplete#user_mappings`

The help documents all options together in `:help mucomplete-customization`
and does not say which of them are read once. The rest
(`g:mucomplete#completion_delay`, `g:mucomplete#minimum_prefix_length`, ...)
are read on demand and can be changed at any time.

### Fix

Add a short paragraph at the top of `:help mucomplete-customization` listing
the options that are read once at load time and must be set before MUcomplete
is loaded, and note that the remaining options are read at runtime. A short
note under each affected option would help too.
