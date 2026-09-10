# doc: warn that the old pop-up plugs do not exist on current Vim

## What happens

`<plug>(MUcompleteCR)` (with `<plug>(MUcompletePopupCancel)` and
`<plug>(MUcompletePopupAccept)`) is only defined for Vim 8.0.0282 and older.
An expression mapping that returns one of them on Vim 8.0.0283 or later does
not resolve the `<Plug>`, so the plug name is inserted as literal text.  For
example, after confirming a completion the characters
`<Plug>(MUcompleteCR)` are appended to the inserted text.

The help already says the plugs are old-only, but the plug list does not
mention that an undefined plug is inserted literally, and the version note is
easy to miss when copying one of the examples.

## Fix

State the consequence explicitly in the plug list, and point to the supported
`<cr>` mapping in `mucomplete-tips`:

    The following plugs are defined only in Vim 8.0.0282 or older.  They do
    not exist in Vim 8.0.0283 and later, so an expression mapping that
    returns one of them on a current Vim inserts the plug name as literal
    text.  On Vim 8.0.0283 and later, map <cr> as shown in
    |mucomplete-tips| instead.

## Changes

* `doc/mucomplete.txt`: one paragraph in `mucomplete-plugs`.

## Notes

* Documentation only; no plugin code is changed.
