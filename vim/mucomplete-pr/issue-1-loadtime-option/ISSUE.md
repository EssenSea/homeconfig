# Options read once at load time are not marked in the docs

Hi, and thanks for MUcomplete!

A few options seem to be evaluated only once, when the plugin is loaded, so
setting them later has no effect:

* `g:mucomplete#no_mappings`
* `g:mucomplete#enable_auto_at_startup`
* `g:mucomplete#chains`
* `g:mucomplete#spel#regex`
* `g:mucomplete#use_only_windows_paths`
* `g:mucomplete#user_mappings`

The help documents all options together in `:help mucomplete-customization`
and does not say which of them are read once.  The rest
(`g:mucomplete#completion_delay`, `g:mucomplete#minimum_prefix_length`,
`g:mucomplete#popup_direction`, ...) are read on demand inside functions and
can be changed at any time, so it is easy to assume they all behave that way.

### Fix

Add a short paragraph at the top of `:help mucomplete-customization` listing
the options that are read once at load time and must be set before MUcomplete
is loaded, and note that the remaining options are read at runtime.  A short
note under each affected option would help too.

I can send a docs patch.
