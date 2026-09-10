# How to submit (manual steps only)

Upstream moved to Codeberg:

    https://codeberg.org/lifepillar/vim-mucomplete

GitHub (https://github.com/lifepillar/vim-mucomplete) is kept as a mirror;
its master may differ from the Codeberg default branch.

## Structure

One combined issue describes all three items, each written as
"what the help already says" / "what is different" / "Fix":

* `ISSUE.md`

Three independent PRs (the issue says patches can be sent separately):

* `pr-1-mucompletecr-literal/`  — plug list: spell out that the old pop-up
  plugs become literal text on current Vim (docs only, 1 commit)
* `pr-2-ultisnips-autopairs/`   — make the UltiSnips example match the
  SnipMate example's `pumvisible()` shape (docs + test, 2 commits)
* `pr-3-loadtime-option/`       — document the remaining load-time options
  (docs, 1 commit)

Each PR folder has `PR-description.md` plus two patch sets:

* `codeberg/`  based on Codeberg HEAD 5000155
* `github/`    based on GitHub master bfc434a

`pr-2` is the strongest item (the help is internally inconsistent); consider
sending it first if you want a quick confirmation of the direction.

## Suggested flow

1. Open the combined issue using `ISSUE.md`.
2. Send the patches as separate PRs (or wait for the maintainer's reply
   first; he usually prefers a short discussion, see #204, #205, #215).

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
