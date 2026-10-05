# dot-github

`dot-github` is the local checkout of `Kopie-Quant-LLC/.github`, the organization's shared GitHub repository. It holds the reusable CI/CD workflows that other kq repositories call, the pull-request gate for itself, the issue and pull-request templates, the code owners file, the label specification, and the organization profile page.

It is not a product. It serves every product indirectly: the repositories that build and deploy the kq products call its workflows by release tag. It contains YAML, Markdown, one generated JSON file (`docs/code-map.json`), the plain-text `CODEOWNERS` file, and images. It has no manifest, no build and no test suite.

## What is in it

| Path | What it holds | State |
|---|---|---|
| `.github/workflows/ci.yml` | This repository's pull-request gate (`CI — PR Gate`). Runs one job, `Commit Trailer Check`, on `pull_request` into `main`. | built, live |
| `.github/workflows/reusable-*.yml` | 11 callable workflows (`workflow_call`). See [Reusable workflows](#reusable-workflows). | built, 5 live, 6 unreached |
| `.github/workflows/agents-md-header-sync.yml` | Weekly drift check of the `AGENTS.md` canonical header across repositories. | built, live |
| `.github/CODEOWNERS` | Owner of `*`, `/workflow-templates/` and `/.github/workflows/` is `@YXZYSME`. The `/workflow-templates/` directory does not exist. | built, live |
| `.github/ISSUE_TEMPLATE/` | `bug_report.md`, `feature_request.md`, `infra_change.md`. There is no `config.yml`. | built, live |
| `.github/PULL_REQUEST_TEMPLATE.md` | Sections: Summary, Type of Change, Testing Done, HITL Required, Related Issues. | built, live |
| `AGENTS.md` | Agent instructions. Lines 1-72 are the protected canonical header. The rest is a repo-local body. See [AGENTS.md](AGENTS.md). | built, partly stale |
| `LABELS.md` | The 25-label specification (4 priority, 3 review, 5 scope, 5 status, 8 type). See [LABELS.md](LABELS.md). | built, partly stale |
| `profile/` | `README.md` is the public organization profile, with the PNG banners it shows. | built, live |
| `docs/code-map.json` | Generated map from the retired Jules bot. It lists workflows that no longer exist. | stale, do not use |

Not in this repository: `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `dependabot.yml`, `workflow-templates/`, `.github/hosted-runner-allow`, and any runner-routing guard. Dependabot and the Jules workflows were removed in commits `7a884bf` and `cbee828`.

## How it works

The repository has two kinds of workflow file.

- **Callable files.** Each `reusable-*.yml` carries only `workflow_call`. A caller in another repository runs it with `uses:` and passes inputs.
- **Triggered files.** `ci.yml` runs on pull requests into `main`. `agents-md-header-sync.yml` runs on `workflow_dispatch` and on a Monday 14:30 UTC cron.

A caller names a lane and a release tag:

```yaml
uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-commit-trailer.yml@v1.5.0
```

A change on `main` does not reach any caller in another repository until a release tag is cut. Tags `v1.0.1` through `v1.5.1` exist. Every caller in another repository at the kq root pins the exact tag `v1.5.0`, one release behind the newest tag `v1.5.1`. This repository's `ci.yml` calls `reusable-commit-trailer.yml` by local path (`./.github/workflows/reusable-commit-trailer.yml`), so it runs the version on the pull request's commit, not a tag. No floating major tag (`v1`) exists. `main` is two comment-only commits ahead of `v1.5.1`.

### Reusable workflows

Most lanes run on `[self-hosted, macOS, ARM64]`. Four jobs run on hosted `ubuntu-latest`: the three jobs in `reusable-security.yml` and the plan job in `reusable-terraform-plan.yml`.

| File | What it does | Callers at the kq root (`@v1.5.0`) |
|---|---|---|
| `reusable-commit-trailer.yml` | Checks every commit in the range. Requires `Signed-off-by` from an allow-listed identity and an `Engineered-By` trailer. Rejects `Co-authored-by` trailers that name an AI tool. Derives the range per event (`pull_request`, `pull_request_target`, `push`). | `kq-terminal`, `kq-l1-data-engineering`, `kq-infra`, `kq-client-management`, `sites/kq-website`, and this repository's `ci.yml` (by local path, not `@v1.5.0`) |
| `reusable-branch-name-check.yml` | Passes `dependabot/`, `builder/` and `jules/` branches. Requires every other branch to match `feat\|fix\|chore\|docs\|refactor\|test\|ci\|perf\|build\|revert\|epic\|epic-<N>` followed by `/` and a non-empty slug (`<type>/<slug>`). Pull-request only. | same five repositories (not this repository) |
| `reusable-docker-build-scan.yml` | Builds an image, scans it with Trivy (`HIGH,CRITICAL`, fails the job), uploads SARIF, and pushes to ECR only when `push` is `true`. Output: `image-uri`. | `kq-terminal`, `kq-l1-data-engineering`, `kq-l1-compute-orchestration` |
| `reusable-ecs-deploy.yml` | Rolling ECS deploy, not blue/green. Renders the new image into the task definition. If the service `desiredCount` is 0, it registers the task definition and stops. Otherwise it deploys and waits up to 10 minutes for stability. If the deploy step fails, it moves the service to the family's latest revision minus 1 with `--force-new-deployment`. After a successful deploy it runs an optional health check against a URL held in SSM (10 tries, 6 s apart). A failed health check fails the job but does not roll back. Environment `production`. | `kq-terminal` |
| `reusable-static-cloudfront.yml` | Builds a static site, refuses an empty output directory, syncs to S3 with `--delete`, and invalidates `/*` on the CloudFront distribution whose id is read from SSM. Environment `production`. | `sites/kq-website` |
| `reusable-node-ci.yml` | `npm ci`, lint, build, test. Defaults: Node 20, `npm run build`. | none (built, unreached) |
| `reusable-python-ci.yml` | Installs requirements, runs `ruff check .` and `pytest`. Default Python 3.11. No format check. | none (built, unreached) |
| `reusable-rust-ci.yml` | `cargo fmt --all --check`, `cargo clippy --all-targets --all-features -- -D warnings`, `cargo test --all`. | none (built, unreached) |
| `reusable-security.yml` | Three hosted jobs: gitleaks secret scan (fails on a find), dependency audit by language (`pip-audit` and `npm audit` do not fail the job), and Trivy container scan when `docker-context` is set. It does not run tfsec. | none (built, unreached) |
| `reusable-terraform-plan.yml` | `terraform fmt -check`, `init`, `validate`, TFLint, tfsec, Checkov, then `plan`. Hosted runner, because tfsec and Checkov are Docker-container actions. Needs secret `AWS_ACCOUNT_ID`. Posts no pull-request comment and uploads no plan file. Default Terraform 1.7. | none (built, unreached) |
| `reusable-terraform-apply.yml` | Downloads an artifact named `tfplan` and runs `terraform apply -auto-approve`. Environment `production`. Default Terraform 1.9.5. | none (built, unreached) |

The caller list covers only the repositories checked out at the kq root, on their checked-out branches. Callers on other branches or in other repositories are not shown.

Known defects in the callable files:

- `reusable-terraform-apply.yml` expects a `tfplan` artifact that no workflow in this repository produces. The caller must supply it.
- The only approval gate on `production` jobs is the GitHub environment protection. That setting is not in this repository and was not verified.
- `reusable-branch-name-check.yml` reads `github.head_ref` inside an inline script. `actionlint` flags it as injectable.

### Commit trailer rule as enforced

CI requires more than the canonical header in `AGENTS.md` states. The header requires a `Signed-off-by` trailer and bans AI `Co-Authored-By` trailers. It does not mention `Engineered-By`, which the workflow requires on every commit. The workflow also accepts only the six `Signed-off-by` identities listed in `reusable-commit-trailer.yml`. A pull request into this repository fails `Commit Trailer Check` without them.

### Header drift check

`agents-md-header-sync.yml` diffs the `BEGIN`/`END` canonical header block in each target's `AGENTS.md` against `kq-knowledge/.kq/AGENTS-CANONICAL-HEADER.md`, using the secret `KQ_SYNC_PAT`. It opens an issue labelled `agents-md-drift` in the target repository when the block is missing or differs. Its matrix names 8 repositories: `kq-knowledge`, `kq-terminal`, `kq-admin`, `kq-website`, `kq-infra`, `kq-forge-engine`, `kq-victory-engine` and `.github`. Only `kq-terminal`, `kq-infra`, `sites/kq-website`, `sites/kq-admin` and this repository are present at the kq root. `sites/kq-admin` has no `AGENTS.md`. The canonical source file is not present locally, so the header in `AGENTS.md` cannot be checked here. Do not edit `AGENTS.md` lines 1-72 in this repository.

## How to work on it

Prerequisites: Git. To lint workflows, install `actionlint`. No other toolchain or setup exists.

```bash
actionlint .github/workflows/*.yml
```

On 2026-10-04 (`efc7b74`), this command reported 2 findings: the `head_ref` note in `reusable-branch-name-check.yml` and an unused variable (`SC2034`) in `reusable-ecs-deploy.yml`. No CI job runs `actionlint`.

No local command in this repository is link-class. The only local check is `actionlint`. The `cargo test` and `docker build` steps inside the reusable workflows run on GitHub Actions runners when a caller invokes them. They are not run from this checkout. If a future change adds one, on a Kopie Quant machine it goes through `kq-link` to the farm, for example `kq-link --wait --repo <repo> <name> "<cmd>"`, as `kq-board/kq-logic-board/laws/working-with-kq-farm/README.md` describes.

## Configuration

This repository reads no environment variables and serves no ports. The workflows depend on these names, which live on GitHub or in AWS, not here.

| Name | Used by | Effect |
|---|---|---|
| secret `KQ_SYNC_PAT` | `agents-md-header-sync.yml` | Reads the canonical header and opens drift issues in other repositories. |
| secret `AWS_ACCOUNT_ID` | `reusable-terraform-plan.yml` | Builds the role ARN that the job assumes through OIDC. |
| environment `production` | `reusable-ecs-deploy.yml`, `reusable-static-cloudfront.yml`, `reusable-terraform-apply.yml` | GitHub environment the job runs in. |
| SSM parameter names | `reusable-ecs-deploy.yml` (`health-url-ssm-param`), `reusable-static-cloudfront.yml` (`cloudfront-distribution-ssm-param`) | The caller supplies the parameter name. No fixed key lives here. |
| `aws-region` input | ECS, ECR, CloudFront and apply lanes | Defaults to `us-east-1` where an input exists. |

## Tests

None. This repository has no `tests/` directory. The only local check is `actionlint`, above. `ci.yml` does not exercise the other reusable lanes.

## CI

| Workflow | Trigger | What it gates |
|---|---|---|
| `ci.yml` (`CI — PR Gate`) | `pull_request` into `main`. Cancels an older run on the same ref. Permission `contents: read`. | Commit trailers only. It runs no branch-name check, no `actionlint`, and no lane test. It has no `merge_group` trigger. |
| `agents-md-header-sync.yml` | `workflow_dispatch` and Monday 14:30 UTC | Not a gate. Opens drift issues. |

Whether `Commit Trailer Check` is a required status check on `main` is set in GitHub rulesets. It is not in this repository and was not verified.

## Branches and how work lands

Law: `kq-board/kq-logic-board/github-environment-rules/branch-classes.md`.

That page puts `dot-github` (`Kopie-Quant-LLC/.github`) in the class "Not running right now": the Pipeline & Quality Loop does not cover it yet. The table lists branches `main` and `development`, with `main` as the only branch today. Its "how work lands" cell reads: development; once the Pipeline & Quality Loop covers it, a pull request into `main` that the CEO merges. The CEO merges `main`.

Local state differs from the table. The checkout has `main` and three topic branches (`ci/self-hosted-runners`, `ci/terraform-plan-hosted`, `fix/commit-trailer-event-aware`) whose changes were already squash-merged. No `development` branch exists locally or among the remote-tracking refs. Remote state was not re-fetched. History shows work arriving as pull requests into `main`, and `AGENTS.md` says never push directly to `main`.

Two board pages disagree on this repository's status. `branch-classes.md` lists it as not running with a `development` branch. `kq-board/kq-logic-board/development-loops/colby/pr-routes/README.md` lists it as active, with a topic branch and a pull request into `main` and no `development` base. The code agrees with `pr-routes`. The branch class table is the law, and this disagreement is unresolved.

Landing a change on `main` does not deploy it. Callers in other repositories receive a change only after a release tag is cut.

## Board and related pages

| Page | Governs |
|---|---|
| `kq-board/kq-logic-board/github-environment-rules/README.md` | GitHub Environments & Rules, the index. |
| `kq-board/kq-logic-board/github-environment-rules/branch-classes.md` | Branch class of this repository. |
| `kq-board/kq-logic-board/github-environment-rules/law.md` | Runner law: jobs run on the Mac mini unless they need Linux. This repository has no runner-routing guard and no hosted-runner allow-list file, and runs four hosted jobs. |
| `kq-board/kq-logic-board/github-environment-rules/ci-cd-rules.md` | CI runs locally first, GitHub confirms. |
| `kq-board/kq-logic-board/devops-architecture/github-workflows-architecture.md` | Target workflow layout. It describes planned lanes this repository does not have yet: `reusable-gate-*`, `reusable-battery`, `reusable-smoke`, `reusable-gitignore-guard`, a floating major tag and a `merge_group` trigger. Treat those as planned, not built. |
| `kq-board/kq-logic-board/development-loops/colby/pr-routes/README.md` | Where landed work goes. |
| `kq-board/kq-logic-board/laws/working-with-kq-farm/README.md` | Running link-class jobs through `kq-link`. |

Repositories that call this one: `kq-terminal`, `kq-l1-data-engineering`, `kq-l1-compute-orchestration`, `kq-infra`, `kq-client-management`, `sites/kq-website`.

## Owner

`.github/CODEOWNERS` names `@YXZYSME` (the CTO) as owner. Escalate to Sun YXZYS (CTO).
