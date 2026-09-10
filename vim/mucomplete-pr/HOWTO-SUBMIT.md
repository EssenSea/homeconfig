# How to submit (manual steps only)

Upstream moved to Codeberg:

    https://codeberg.org/lifepillar/vim-mucomplete

GitHub (https://github.com/lifepillar/vim-mucomplete) is kept as a mirror;
its master may differ from the Codeberg default branch.  For each item below
there are two patch sets:

* `codeberg/`  based on Codeberg HEAD 5000155
* `github/`    based on GitHub master bfc434a

## Items

### issue-1-loadtime-option

`doc: mark options that are read once at load time` — one docs-only commit.

### issue-2-ultisnips-autopairs

`docs: keep UltiSnips snippets in Insert mode with Auto Pairs` — two commits
(docs + test).

The two items are independent and can be sent as separate issues/PRs.

## Suggested flow: issue first, then PR

The maintainer prefers a short discussion first (see issues #204, #205, #215).
Use each `ISSUE.md` as the issue body, then the matching `PR-description.md`
when opening the PR.

## Fork, branch, apply patches

    git clone git@codeberg.org:<you>/vim-mucomplete.git
    cd vim-mucomplete
    git remote add upstream https://codeberg.org/lifepillar/vim-mucomplete.git
    git fetch upstream

    # issue 1
    git checkout -b doc/load-time-options upstream/master
    git am /path/to/mucomplete-pr/issue-1-loadtime-option/codeberg/*.patch

    # issue 2 (separate branch/PR)
    git checkout -b fix/ultisnips-autopairs upstream/master
    git am /path/to/mucomplete-pr/issue-2-ultisnips-autopairs/codeberg/*.patch

Then push each branch and open the PR with the matching `PR-description.md`.

If you cannot use Codeberg, use the `github/` patches against the mirror.

## Verification

* `issue-1`: open `doc/mucomplete.txt` in Vim and check `:help load-time-option`
  resolves; run `:helptags doc` and confirm `doc/tags` still has no duplicate
  entries.
* `issue-2`: with Vim 9.2 + UltiSnips + auto-pairs, choosing a `[snip]` entry
  should expand the snippet and stay in Insert mode; a plain `<cr>` should
  still get auto-pairs' bracket-return behaviour.
