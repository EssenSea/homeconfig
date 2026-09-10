# doc: mark options that are read once at load time

## What happens

A few `g:mucomplete#...` options are evaluated only once, when MUcomplete
is loaded:

* `g:mucomplete#no_mappings` — read in a top-level `if` in
  `plugin/mucomplete.vim` (and again in `autoload/mucomplete.vim`) to decide
  whether Tab/S-Tab and `<c-j>`/`<c-h>` are mapped;
* `g:mucomplete#enable_auto_at_startup` — read in `plugin/mucomplete.vim` to
  decide whether to call `mucomplete#auto#enable()`;
* `g:mucomplete#chains`, `g:mucomplete#user_mappings`,
  `g:mucomplete#use_only_windows_paths`, `g:mucomplete#spel#regex` — read at
  the top level of `autoload/mucomplete.vim` and merged into the defaults
  with `extend()`.

If they are set after the plugin (or after the autoload script has been
sourced), they have no effect.  The help documents all options together, so
it is not obvious which ones are read once and which are read on demand.

## Fix

Add a short paragraph at the top of `*mucomplete-customization*` that lists
the load-time options and states that they must be set before MUcomplete is
loaded; introduce a `*load-time-option*` tag and add a one-line note to each
affected option.  Mention that the remaining options are read on demand and
can be changed at any time.

## Changes

* `doc/mucomplete.txt`: the paragraph and the six per-option notes.
* `doc/tags`: regenerated (`helptags`), added `load-time-option`.

## Notes

* Documentation only; no plugin code is changed.
* `g:mucomplete#user_mappings` already had a similar note; it is reworded to
  use the new tag, keeping the existing advice about
  `mucomplete#add_user_mapping()`.
