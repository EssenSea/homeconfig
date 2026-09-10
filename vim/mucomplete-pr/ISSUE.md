# UltiSnips + Auto Pairs example, `<Plug>(MUcompleteCR)`, and option timing

Hi, and thanks for MUcomplete!

I use Vim 9.2 with UltiSnips and auto-pairs. Three things I ran into, with
what I think the docs should say instead.

## 1. `<Plug>(MUcompleteCR)` is only defined on old Vim

Following the pop-up-mapping examples, I had this in my vimrc:

```vim
function! CompleteCR()
  if pumvisible()
    return "\<Plug>(MUcompleteCR)"
  endif
  return "\<CR>"
endfunction
inoremap <silent> <expr> <CR> CompleteCR()
```

On my Vim, `<Plug>(MUcompleteCR)` is not defined: it only exists in Vim
8.0.0282 and earlier, per `:help mucomplete-plugs`. An expression mapping
that returns an undefined `<Plug>` inserts it as literal text, so after
confirming a completion the characters `<Plug>(MUcompleteCR)` were appended
to the inserted text.

### Fix

On Vim 8.0.0283 and later the pop-up mappings are not defined, and the
supported form is simply:

```vim
inoremap <expr> <cr> pumvisible() ? "<c-y><cr>" : "<cr>"
```

The docs already give this in `mucomplete-tips` (the "does not always insert
a new line" question). The fix is to make the older-Vim examples that use
`<Plug>(MUcompleteCR)` refer to that form, or to mark them more explicitly,
so a current-Vim user does not copy a plug that no longer exists.

## 2. `UltiSnips + Auto Pairs`: snippet leaves Insert mode

With the `UltiSnips + Auto Pairs` example:

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

choosing a `[snip]` entry from the pop-up and pressing `<cr>` expands the
snippet, but Vim ends up in Normal mode and the jump trigger no longer moves
between placeholders. `<plug>AutoPairsReturn` is chained after
`<plug>UltiExpand`, so it also runs right after the expansion; its
`<esc>`-based return handling is what leaves Insert mode.

### Fix

Put `<plug>AutoPairsReturn` only in the non-pop-up branch, the same shape the
`SnipMate + Auto Pairs` example already uses:

```vim
inoremap <silent> <expr> <plug>UltiExpand
      \ mucomplete#ultisnips#expand_snippet("\<cr>")
imap <silent> <expr> <plug>MyCR (pumvisible()
    \ ? "\<plug>UltiExpand"
    \ : "\<cr>\<plug>AutoPairsReturn")
imap <cr> <plug>MyCR
```

A plain `<cr>` still gets auto-pairs' bracket-return behaviour, while
accepting a snippet stays in Insert mode.

## 3. Some options are read when the plugin loads, but the docs do not say so

A few options are evaluated once, at load time, not on every completion:

* `g:mucomplete#no_mappings` — read in a top-level `if` in
  `plugin/mucomplete.vim` (and again in `autoload/mucomplete.vim`) to decide
  whether Tab/S-Tab and `<c-j>`/`<c-h>` are mapped;
* `g:mucomplete#enable_auto_at_startup` — read in `plugin/mucomplete.vim` to
  decide whether to call `mucomplete#auto#enable()`;
* `g:mucomplete#chains`, `g:mucomplete#user_mappings`,
  `g:mucomplete#use_only_windows_paths`, `g:mucomplete#spel#regex` — read at
  the top level of `autoload/mucomplete.vim` and merged into defaults with
  `extend()`.

If any of these is set after the plugin (or after the autoload script has
been sourced), the setting has no effect, or only the defaults are used.
This is not obvious from the help, because it documents all options
together and does not say which of them are read once.

The rest of the documented options (`g:mucomplete#completion_delay`,
`g:mucomplete#minimum_prefix_length`, `g:mucomplete#popup_direction`, ...)
are read with `get(g:, ...)` inside functions, so they can be changed at any
time. Because the docs describe all of them side by side, the load-time ones
are easy to miss.

### Fix

Add a short paragraph at the top of `:help mucomplete-customization` listing
the options that are read once at load time and must be set before the
plugin is loaded, and note that the remaining options are read at runtime.
A one-line `Note` under each affected option would work too.

I can send docs patches for the three items above.
