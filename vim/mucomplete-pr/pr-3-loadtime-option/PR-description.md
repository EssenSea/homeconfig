# doc: document the remaining options read once at load time

## What the help already says

`g:mucomplete#user_mappings` already notes that it "is read only once when
MUcomplete is loaded" and suggests `mucomplete#add_user_mapping()` for later
definitions.

## What is different

The same is true for

* `g:mucomplete#no_mappings`
* `g:mucomplete#enable_auto_at_startup`
* `g:mucomplete#chains`
* `g:mucomplete#spel#regex`
* `g:mucomplete#use_only_windows_paths`

but none of them say so, even though they sit next to options that are read
on demand and can be changed at any time.

## Fix

Add a short paragraph at the top of `*mucomplete-customization*` listing the
options that are read once at load time and must be set before MUcomplete is
loaded, state that the remaining options are read at runtime, introduce a
`*load-time-option*` tag, and add a one-line note to each of the five options
above (mirroring the existing `user_mappings` note).

## Changes

* `doc/mucomplete.txt`: the paragraph and the six per-option notes.
* `doc/tags`: regenerated (`helptags`), added `load-time-option`.

## Notes

* Documentation only; no plugin code is changed.
