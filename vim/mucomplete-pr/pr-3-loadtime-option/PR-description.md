# doc: mark options that are read once at load time

## What happens

A few options are evaluated only once, when the plugin is loaded:

* `g:mucomplete#no_mappings`
* `g:mucomplete#enable_auto_at_startup`
* `g:mucomplete#chains`
* `g:mucomplete#spel#regex`
* `g:mucomplete#use_only_windows_paths`
* `g:mucomplete#user_mappings`

If they are set after the plugin (or after the autoload script has been
sourced), they have no effect.  The help documents all options together, so
it is not obvious which ones are read once and which are read on demand.

## Fix

Add a short paragraph at the top of `*mucomplete-customization*` listing the
load-time options and stating that they must be set before MUcomplete is
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
