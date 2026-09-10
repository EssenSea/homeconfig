# How to submit (manual steps only)

Upstream moved to Codeberg:

    https://codeberg.org/lifepillar/vim-mucomplete

GitHub (https://github.com/lifepillar/vim-mucomplete) is kept as a mirror.
If you have to choose one place, use **Codeberg**.

Two patch sets are provided and apply cleanly:

* `./codeberg/`      based on Codeberg HEAD 5000155  → for a Codeberg PR
* `./github/`        based on GitHub master bfc434a  → for a GitHub PR

Each contains the same two commits:

    0001-Fix-UltiSnips-Auto-Pairs-example-keep-snippets-in-In.patch
    0002-test-expand_snippet-returns-fallback-keys-without-a-.patch

## Recommended flow: issue first, then PR

The maintainer is responsive but prefers to discuss before accepting changes
(see issues #204, #205, #215).  Opening a short issue first greatly improves
the odds of the PR being merged.

### Step 1 — open the issue

Use `ISSUE.md` as the body.  Title suggestion:

    UltiSnips + Auto Pairs example leaves the just-expanded snippet

Post it at:

    https://codeberg.org/lifepillar/vim-mucomplete/issues/new

(Tip: if Codeberg is flaky, retry the page a couple of times.)

### Step 2 — wait for feedback

If the maintainer asks for a different style, adjust the patch (the
alternative explicit form is noted at the end of `PR-description.md`).

### Step 3 — fork, branch, apply patches

    git clone git@codeberg.org:<you>/vim-mucomplete.git
    cd vim-mucomplete
    git remote add upstream https://codeberg.org/lifepillar/vim-mucomplete.git
    git fetch upstream
    git checkout -b fix/ultisnips-autopairs-docs upstream/master   # or 5000155
    git am /path/to/mucomplete-pr-v2/codeberg/0001-*.patch
    git am /path/to/mucomplete-pr-v2/codeberg/0002-*.patch

### Step 4 — push and open the PR

    git push -u origin fix/ultisnips-autopairs-docs

Open the PR against `lifepillar/vim-mucomplete`, using `PR-description.md`
as the body.

## If you cannot use Codeberg

Use the `./github/` patches against the GitHub mirror and open the PR there.
The same PR description applies, but mention that you are not sure whether
the GitHub mirror is still the active one.

## Quick manual verification

Load this mapping in Vim 9.2 with UltiSnips + auto-pairs:

    let g:AutoPairsMapCR = 0
    let g:AutoPairsMapSpace = 0
    imap <silent> <expr> <space> pumvisible()
      \ ? "<space>"
      \ : "<c-r>=AutoPairsSpace()<cr>"
    inoremap <silent> <expr> <plug>UltiExpand
          \ mucomplete#ultisnips#expand_snippet("\<cr>")
    imap <silent> <expr> <plug>MyCR (pumvisible()
        \ ? "\<plug>UltiExpand"
        \ : "\<cr>\<plug>AutoPairsReturn")
    imap <cr> <plug>MyCR

Expected:

* no pop-up: `<cr>` does a normal newline and keeps auto-pairs' bracket
  return behaviour;
* `[snip]` chosen: the snippet expands and stays in Insert mode, so the
  UltiSnips jump trigger keeps working.

Before the fix, the second case leaves Normal mode.
