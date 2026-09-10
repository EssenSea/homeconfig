# How to submit this fix (manual steps)

The upstream project moved to Codeberg:

    https://codeberg.org/lifepillar/vim-mucomplete

The GitHub repository (https://github.com/lifepillar/vim-mucomplete) is a
mirror; its current master may be newer than the Codeberg default branch.
Two patch sets are provided:

  * ./0001-*.patch, ./0002-*.patch
        Based on the Codeberg HEAD (5000155) — use this for a Codeberg PR.
  * ./github-version/0001-*.patch, ./github-version/0002-*.patch
        Based on the GitHub master (bfc434a) — use this if you open a PR
        against the GitHub mirror instead.

Both patch sets contain the same logical change and apply cleanly.

## Option A: fork on Codeberg and open a PR

1. Create a Codeberg account (if needed) and fork:
      https://codeberg.org/lifepillar/vim-mucomplete/fork

2. Clone your fork and add the upstream remote:

      git clone git@codeberg.org:<you>/vim-mucomplete.git
      cd vim-mucomplete
      git remote add upstream https://codeberg.org/lifepillar/vim-mucomplete.git

3. Create a branch and apply the patches:

      git checkout -b fix/ultisnips-autopairs-docs
      git am /path/to/mucomplete-pr/0001-*.patch
      git am /path/to/mucomplete-pr/0002-*.patch

4. Push to your fork:

      git push -u origin fix/ultisnips-autopairs-docs

5. Open the PR against lifepillar/vim-mucomplete with the description in
   `PR-description.md`.

   If network access to Codeberg is flaky, you can also push the same branch
   to the GitHub mirror and open the PR there.

## Option B: no account / send patches by e-mail or issue

The patches are `git format-patch` output, so they can be attached directly
to an issue or sent as-is.

## Before/after quick check

The corrected example is:

    inoremap <silent> <expr> <plug>UltiExpand
          \ mucomplete#ultisnips#expand_snippet(
          \     "\<cr>\<plug>AutoPairsReturn")
    imap <cr> <plug>UltiExpand

To verify manually, with Vim 9.2 + UltiSnips + auto-pairs:

  * no pop-up: <cr> does a normal newline and keeps auto-pairs' bracket
    return behaviour;
  * [snip] chosen: the snippet expands and stays in Insert mode, so the
    UltiSnips jump trigger keeps working.
