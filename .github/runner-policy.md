# Runner policy — the one control panel for CI runners

This repository is the one place that decides which runner a pull request's gate takes (CEO, 2026-11-19). A product repository's
`ci.yml` is one job that calls [`workflows/product-gate.yml`](workflows/product-gate.yml) at a tag. The gate reads the PR's target
branch and picks the runner, so no product repository names a runner for its PR gate.

## The classes

| Repository class | Repositories | PR into `main` | PR into `integration` (or any other branch) |
|---|---|---|---|
| Product | kq-core-backend, kq-console, kq-client-s3-engine, kq-l1-data-engineering, kq-l1-compute-orchestration, kq-terminal, kq-infra | the whole gate, on `ubuntu-latest` (GitHub-hosted) | the intake gate, on the mini (`self-hosted`, `macOS`, `ARM64`) |
| Internal | .claude, kq-atlas, kq-farm, kq-farm-dispatch, kq-development-env, .github, kq-website | the mini | the mini |

Release, battery, deploy and build workflows are not PR gates. They keep the runner they name.

## The switch

The runner of each product target is one expression in `product-gate.yml`:

```text
runs-on: ${{ fromJSON(github.base_ref == 'main'
                      && (vars.KQ_RUNNER_PR_MAIN || '["ubuntu-latest"]')
                      || (vars.KQ_RUNNER_PR_INTEGRATION || '["self-hosted","macOS","ARM64"]')) }}
```

- `github.base_ref` is the caller's: GitHub associates the `github` context of a called workflow with the caller workflow.
- `vars` is the caller repository's, which includes the organization's variables it can see: for a reusable workflow, GitHub reads
  the variables of the caller's repository, never of this one. An unset variable reads as an empty string, so the default after `||`
  applies.
- Both facts are stated by GitHub's documentation (Contexts reference; Variables reference, "Configuration variable precedence"),
  read 2026-11-19. Not yet observed on a run: the first product PR into `main` on the shared gate observes them.

| Organization variable | Value | Who sets it |
|---|---|---|
| `KQ_RUNNER_PR_MAIN` | `["ubuntu-latest"]` | the CEO, once, in the organization's Actions variables, visible to private repositories |
| `KQ_RUNNER_PR_INTEGRATION` | `["self-hosted","macOS","ARM64"]` | the CEO, the same way |

The variables are optional. With neither set, the defaults above hold, which are the same values. Set one to move every product
repository at once, with no tag and no pin move: for example `["self-hosted","macOS","ARM64"]` in `KQ_RUNNER_PR_MAIN` sends the
PRs into `main` back to the mini.

## How a change rolls out

1. Change a workflow here on a branch, and open a PR into `main`. The CEO merges it.
2. Tag the merge: a new major tag (`v2.0.0`) when a caller must change its inputs, a minor tag when it need not.
   Before the tag, the same commit moves the two guard calls inside `product-gate.yml` to the new tag's name, because a called
   workflow cannot name its own repository by a relative path.
3. Move each product caller's pin (`product-gate.yml@vX.Y.Z`) in one PR per repository, opened together, so every product gate
   moves in the same round.
4. A runner change alone needs no tag: it is an organization variable.

## The guards

- [`reusable-runner-routing-guard.yml`](workflows/reusable-runner-routing-guard.yml): a product job takes a hosted runner only through
  this switch. A hosted label listed in the repository's own `.github/hosted-runner-allow` stays allowed, and any other hosted label is
  refused by name.
- [`reusable-gitignore-guard.yml`](workflows/reusable-gitignore-guard.yml): the gitignore guard, run once from the shared gate.

## Cost

Hosted minutes on private repositories are billed (the law "CI/CD runs on the Mac mini" followed $8.27 spent in one morning,
2026-09-01). The CEO approved the reversal for a product PR into `main` on 2026-11-19. The billed minutes of one gate per product
are measured on the first PRs into `main` and written into each repository's `.github/ci-timings.toml` and the law page.
