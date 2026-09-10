# How to submit (manual steps only)

Upstream moved to Codeberg:

    https://codeberg.org/lifepillar/vim-mucomplete

GitHub (https://github.com/lifepillar/vim-mucomplete) is kept as a mirror.

## Structure

One issue, framed as a possible misunderstanding rather than a bug:

* `ISSUE.md` — the two "snippet + Auto Pairs" examples use different shapes;
  ask whether the UltiSnips one should match the SnipMate one.

One optional PR (send only if the maintainer agrees):

* `pr-ultisnips-autopairs/`
  * `PR-description.md`
  * `codeberg/` based on Codeberg HEAD 5000155
  * `github/`   based on GitHub master bfc434a

Patch sets (2 commits: docs + test) apply cleanly to both baselines.

## Suggested flow

1. Open the issue using `ISSUE.md`. Keep it short; the maintainer usually
   replies before accepting changes (see #204, #205, #215).
2. If the direction is agreed, apply the patches and open the PR with
   `PR-description.md`.

    git clone git@codeberg.org:<you>/vim-mucomplete.git
    cd vim-mucomplete
    git remote add upstream https://codeberg.org/lifepillar/vim-mucomplete.git
    git fetch upstream

    git checkout -b docs/ultisnips-autopairs upstream/master
    git am /path/to/mucomplete-pr/pr-ultisnips-autopairs/codeberg/*.patch
    git push -u origin docs/ultisnips-autopairs

Use the `github/` patches if you submit against the mirror instead.

## Note

This materials set was deliberately reduced to the single item with the
clearest inconsistency. The `<Plug>(MUcompleteCR)` literal-text case and the
load-time option case were dropped: the help already mentions the relevant
version notes, and the remaining points read as implementation details or
personal preference rather than doc issues.
