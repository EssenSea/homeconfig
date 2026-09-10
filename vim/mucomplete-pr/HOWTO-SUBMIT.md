# How to submit (manual steps only)

Upstream moved to Codeberg:

    https://codeberg.org/lifepillar/vim-mucomplete

GitHub (https://github.com/lifepillar/vim-mucomplete) is kept as a mirror;
its master may differ from the Codeberg default branch.

## Structure

One combined issue describes all three problems:

* `ISSUE.md`  — post this once (lists items 1, 2 and 3)

Three independent PRs, one per item:

* `pr-1-mucompletecr-literal/`  — warn that the old pop-up plugs do not
  exist on current Vim (docs only, 1 commit)
* `pr-2-ultisnips-autopairs/`   — keep UltiSnips snippets in Insert mode
  (docs + test, 2 commits)
* `pr-3-loadtime-option/`       — mark options read once at load time
  (docs, 1 commit)

Each PR folder has `PR-description.md` plus two patch sets:

* `codeberg/`  based on Codeberg HEAD 5000155
* `github/`    based on GitHub master bfc434a

## Suggested flow

1. Open the combined issue using `ISSUE.md`.
2. For each item, create a branch, apply its patches and open a PR (or wait
   for the maintainer's reply first; he usually prefers a short discussion,
   see issues #204, #205, #215).

## Fork, branch, apply patches

    git clone git@codeberg.org:<you>/vim-mucomplete.git
    cd vim-mucomplete
    git remote add upstream https://codeberg.org/lifepillar/vim-mucomplete.git
    git fetch upstream

    # PR 1
    git checkout -b doc/mucomplete-old-plugs upstream/master
    git am /path/to/mucomplete-pr/pr-1-mucompletecr-literal/codeberg/*.patch

    # PR 2
    git checkout -b docs/ultisnips-autopairs upstream/master
    git am /path/to/mucomplete-pr/pr-2-ultisnips-autopairs/codeberg/*.patch

    # PR 3
    git checkout -b doc/load-time-options upstream/master
    git am /path/to/mucomplete-pr/pr-3-loadtime-option/codeberg/*.patch

Push each branch and open a PR with the matching `PR-description.md`.

If you cannot use Codeberg, use the `github/` patches against the mirror.

## Verification

* PR 1: open `doc/mucomplete.txt` and check the plug-list paragraph reads
  well with `:help mucomplete-plugs`.
* PR 2: with Vim 9.2 + UltiSnips + auto-pairs, choosing a `[snip]` entry
  should expand the snippet and stay in Insert mode; a plain `<cr>` should
  still get auto-pairs' bracket-return behaviour.
* PR 3: after `:helptags doc`, check `:help load-time-option` resolves and
  `doc/tags` has no duplicate entries.
