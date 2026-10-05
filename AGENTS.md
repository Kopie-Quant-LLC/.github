<!-- BEGIN KQ CANONICAL HEADER v1.0.0 -->
<!-- DO NOT EDIT between BEGIN/END. Edit source: kq-knowledge/.kq/AGENTS-CANONICAL-HEADER.md -->

## KQ Org-Wide Agent Rules

You are an agent working in the Kopie-Quant-LLC organization. Follow
these rules unless the human operator overrides in chat.

### Commit trailer (required, exactly one of these on the final line)

- `Signed-off-by: Sun YXZYS <sun@yxzys.me>` — Sun-lane repos
  (`kq-terminal`, `kq-admin`, `kq-website`, `kq-infra`, `kq-knowledge`,
  `.github`, `kq-knowledge-graph`)
- `Signed-off-by: Colby VK <c.vail@kopiequant.com>` — Colby-lane repos
  (`kq-forge-engine`, `kq-victory-engine` engine code)

Use the trailer matching the repo owner. If authoring on behalf of the
human operator who invoked you, use that operator's trailer. Never
invent a third identity.

### Banned trailers — never emit these

- `Co-Authored-By:` with Claude / GPT / Copilot / Gemini / Jules / AI /
  Bot / Agent / any non-human identity
- `Generated-By:` with a tool name
- 🤖 emoji anywhere in commit messages or PR bodies
- Any attribution that credits the agent as an author

Org CI has a required `Commit Trailer Check / check`. PRs that violate
these rules will fail CI and be closed.

### Lane discipline

- Never self-merge. Open PRs; assign `@YXZYSME` as reviewer (CODEOWNER).
- Never push directly to `main`.
- Do not modify files in these paths unless the task explicitly targets
  them:
  - `.github/workflows/*.yml` (reserved for workflow-scoped tasks)
  - `**/*.tf` in `kq-infra` (Sun-only Terraform lane)
  - `kq-victory-engine/src/**` and `kq-forge-engine/src/**` (Colby-only
    engine lanes)
  - `.agent/` and `.kq/` directories (infrastructure — explicit task
    only)

### Loop guard

If tests fail after one run, summarize the failure in three bullets,
make the smallest reasonable fix, and open the PR even if tests are
still red. Do not re-grep logs more than twice. Do not enter an
investigation loop.

### Pre-commit hygiene

- Run the repo's formatter + linter (see repo-local README / AGENTS
  body below)
- Run smoke tests when they exist
- Never commit secrets (regex scan: `AKIA`, `ghp_`, `sk-`, `-----BEGIN
  PRIVATE KEY-----`)
- Never commit files > 1 MB

### Authoritative references

- `kq-knowledge/.kq/` — business + strategy + architecture
  (human-curated)
- `kq-knowledge-graph/` — machine-generated structural map (Phase 1+)

### Precedence

explicit-chat-prompt > repo-local AGENTS.md body > this canonical
header > Jules per-repo Memory > Jules default system prompt

<!-- END KQ CANONICAL HEADER v1.0.0 -->

# Kopie-Quant-LLC/.github — Org-Level Reusable Workflows

> This repo (local clone: `dot-github`, GitHub: `Kopie-Quant-LLC/.github`) holds the reusable GitHub
> Actions workflows that estate repos call by release tag, plus the organization's templates and
> profile. It is shared CI/CD infrastructure. It is not a product and it has no application code.

## This Repository

- **Lane:** Sun (infrastructure)
- **Stack:** GitHub Actions YAML, with inline bash and `actions/github-script`. No manifest, no build, no test suite.
- **Purpose:** Hold the reusable CI/CD workflows, the org issue and PR templates, `CODEOWNERS`, the org profile, `LABELS.md`, and the weekly `AGENTS.md` header drift check.
- **Owner:** `@YXZYSME` owns every path (`.github/CODEOWNERS`).

### What is in it

| Path | What it is |
|---|---|
| `.github/workflows/` | 13 workflow files: 11 reusable (`workflow_call`), plus `ci.yml` and `agents-md-header-sync.yml` |
| `.github/ISSUE_TEMPLATE/` | `bug_report.md` (label `type: bug`), `feature_request.md` (label `type: feature`), `infra_change.md` (label `scope: infra`) |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR template: Summary, Type of Change, Testing Done, HITL Required, Related Issues |
| `.github/CODEOWNERS` | `@YXZYSME` for `*`, `/workflow-templates/` and `/.github/workflows/`. The `/workflow-templates/` directory does not exist |
| `LABELS.md` | The 25-label spec. Nothing in this repo applies or syncs labels (see `LABELS.md`) |
| `profile/README.md` | The org landing page, with PNG banners beside it |
| `docs/code-map.json` | Stale generated output from the removed Jules code-map workflow. It lists workflows that no longer exist. Do not rely on it |
| `README.md` | Overview of the repo |

The repo has no `dependabot.yml`, no `workflow-templates/`, no `SECURITY.md`, `CONTRIBUTING.md` or `CODE_OF_CONDUCT.md`, and no `.github/hosted-runner-allow`. Dependabot and the Jules workflows were removed in commits `7a884bf` and `cbee828`.

## The protected header

Lines 1–72 of this file are a copy of the KQ canonical header, owned by `kq-knowledge`. Do not edit them here.
`agents-md-header-sync.yml` diffs that block against `kq-knowledge/.kq/AGENTS-CANONICAL-HEADER.md` and opens an issue when it drifts.
That source file is not present at the kq root, so this copy cannot be regenerated or checked locally.
Where the header and the code disagree, the code wins. Known disagreements:

- The header describes a `Signed-off-by` trailer only. `reusable-commit-trailer.yml` also requires an `Engineered-By:` trailer on every commit (see Commit rules below).
- The header lists Sun-lane and Colby-lane repos that differ from the estate at the kq root, and its precedence line names Jules, which no longer exists here.
- The header says never commit files over 1 MB. Five of the seven PNGs in `profile/` are larger than that (3.3 to 4.8 MB).

Fix these in `kq-knowledge`, not here.

## How consumers use it

An estate repo calls a lane with:

```yaml
uses: Kopie-Quant-LLC/.github/.github/workflows/<file>@<tag>
```

A change on `main` does not reach a caller until a release tag is cut. As of 2026-10-04 the newest tag is `v1.5.1`, and every caller at the kq root pins the exact tag `v1.5.0`. No floating major tag (`v1`) exists. The board law asks callers to use one major tag; this repo does not yet follow it (see Board law).

## Reusable workflows

State key: **live** = a repo at the kq root calls it. **no caller** = built, but no workflow at the kq root calls it today (only the kq root was searched).

| Workflow | What it does | State |
|---|---|---|
| `reusable-commit-trailer.yml` | Per commit in the PR or push range: requires `Signed-off-by` from an allow-listed identity, requires `Engineered-By`, rejects a `Co-authored-by` naming an AI tool. Other events exit 0 with a notice | live (5 callers, plus this repo's `ci.yml`) |
| `reusable-branch-name-check.yml` | Passes `dependabot/`, `builder/` and `jules/` prefixes. Otherwise requires `<type>/<slug>` where type is `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `perf`, `build`, `revert`, `epic` or `epic-<N>`. PR-only: it reads `github.head_ref` | live (5 callers) |
| `reusable-docker-build-scan.yml` | Builds an image, scans with Trivy (HIGH and CRITICAL fail the run), uploads SARIF, pushes to ECR only when `push` is true. Output: `image-uri` | live (5 callers) |
| `reusable-ecs-deploy.yml` | Rolling ECS deploy, not blue/green. Renders the new image into the current task definition. If the service `desiredCount` is 0, it registers the task definition only. Otherwise it deploys, waits up to 10 minutes for stability, runs an optional health check (URL read from an SSM parameter the caller names). If the deploy step fails, it rolls back to the latest revision minus 1 with `--force-new-deployment`. A failed health check fails the job but does not roll back. Runs in environment `production` | live (1 caller) |
| `reusable-static-cloudfront.yml` | Builds a static site, refuses an empty output directory, reads the CloudFront distribution id from a caller-named SSM parameter, runs `aws s3 sync --delete`, then a full `/*` invalidation. Runs in environment `production` | live (1 caller) |
| `reusable-node-ci.yml` | `npm ci`, lint, build, test (Node 20 by default) | no caller |
| `reusable-python-ci.yml` | Installs requirements plus `ruff` and `pytest`, then `ruff check .` and `pytest` (Python 3.11 by default). No format check | no caller |
| `reusable-rust-ci.yml` | `cargo fmt --all --check`, `cargo clippy ... -D warnings`, `cargo test --all` | no caller |
| `reusable-security.yml` | Three jobs: `gitleaks` secret scan, dependency audit (`pip-audit`, `cargo audit` or `npm audit` by the `language` input; `pip-audit` and `npm audit` do not block), Trivy container scan when `docker-context` is set. It has no `tfsec` | no caller |
| `reusable-terraform-plan.yml` | `fmt -check`, `init`, `validate`, TFLint, `tfsec`, Checkov, `terraform plan`. It posts no PR comment and uploads no plan artifact. Needs secret `AWS_ACCOUNT_ID` | no caller |
| `reusable-terraform-apply.yml` | Downloads the artifact named by `plan-artifact` (default `tfplan`) and runs `terraform apply -auto-approve`. The only gate is environment `production`, which is configured on GitHub, not in this repo. No workflow here produces a `tfplan` artifact, because `reusable-terraform-plan.yml` writes no plan file | no caller |

Caller settings: each file's `inputs:` block is the contract. The non-obvious ones, read from those blocks:

- `reusable-ecs-deploy.yml` requires `aws-role-arn`, `cluster`, `service`, `task-family`, `container-name` and `image`.
- `reusable-static-cloudfront.yml` requires `aws-role-arn`, `s3-bucket` and `cloudfront-distribution-ssm-param`.
- `reusable-docker-build-scan.yml` requires `image-tag`. `reusable-security.yml` requires `language`.
- `reusable-terraform-apply.yml` requires `working-directory` and `aws-role-arn`. `reusable-terraform-plan.yml` requires `working-directory`.
- `aws-region` defaults to `us-east-1` in the docker, ecs, cloudfront and terraform-apply lanes. `terraform-version` defaults to `1.7` in plan and `1.9.5` in apply.
- `reusable-terraform-plan.yml` takes no role or region input. It hardcodes the role `GitHubActionsTerraformRole` (ARN built from secret `AWS_ACCOUNT_ID`) and region `us-east-1` at lines 45-46.

Two workflows carry their own triggers and are not callable:

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` ("CI — PR Gate") | `pull_request` into `main` | One job, `Commit Trailer Check`, calling `reusable-commit-trailer.yml` by local path. It runs no branch-name check, no `actionlint`, and no test of the other lanes. There is no `merge_group` trigger |
| `agents-md-header-sync.yml` | `workflow_dispatch` and cron `30 14 * * 1` (Mondays, 14:30 UTC) | For each repo in an 8-repo matrix (`kq-knowledge`, `kq-terminal`, `kq-admin`, `kq-website`, `kq-infra`, `kq-forge-engine`, `kq-victory-engine`, `.github`), compares the `AGENTS.md` header block to the canonical source. Opens an issue labelled `agents-md-drift` on a missing file, a missing header or drift. Uses secret `KQ_SYNC_PAT` |

The sync matrix is out of date against the estate at the kq root. Only `kq-terminal`, `kq-infra` and `.github` (cloned as `dot-github`) have a directory at the kq root. `kq-website` and `kq-admin` live under `sites/` (`sites/kq-website`, `sites/kq-admin`). `kq-knowledge`, `kq-forge-engine` and `kq-victory-engine` have no local clone. The check reads each target repo's default branch on GitHub, not a local working tree. In the local remote-tracking refs (not re-fetched), `kq-terminal`'s `origin/main` has no `AGENTS.md`, so the check reports it as `missing`. `kq-admin`'s `origin/main` has one, although its local checkout (`feat/update-admin-portal`) does not. The estate repos `kq-core-backend`, `kq-l1-data-engineering`, `kq-l1-compute-orchestration`, `kq-client-management` and `kq-enterprise-portal` are not in it. Whether the GitHub-side repos still exist is unverified.

## Runners

Ten workflow files run on `[self-hosted, macOS, ARM64]`. Four jobs run on hosted `ubuntu-latest`: the three jobs in `reusable-security.yml` and the one job in `reusable-terraform-plan.yml` (its comment says Checkov and `tfsec` are Docker-container actions that need Linux). This repo has no runner-routing guard and no `.github/hosted-runner-allow` file, so the hosted jobs are undeclared. `kq-board/kq-logic-board/github-environment-rules/law.md` lists this as a finding.

## Commit rules (enforced by CI)

`ci.yml` runs `Commit Trailer Check` on every PR into `main`. Every commit in the PR must have:

- a `Signed-off-by:` line from one of the allow-listed identities in `reusable-commit-trailer.yml` (Sun YXZYS, in several forms, or Colby VK);
- an `Engineered-By:` line;
- no `Co-authored-by:` trailer that names `claude`, `gpt`, `copilot`, `cursor`, `perplexity`, `computer`, `assistant`, `anthropic` or `openai`.

Whether `Commit Trailer Check / check` is a required status in the GitHub ruleset is not readable from the repo.

## Working in this repo

- Land work as the Branches section below states. The law (`branch-classes.md`) routes work through `development`, but no `development` branch exists yet. Do not create one, and do not pick a route on your own. Ask the CEO. Use a `<type>/<slug>` branch name, never push to `main`, and never self-merge.
- Pass `github.event` and `github.head_ref` values into scripts through `env:`, not by direct interpolation. `reusable-branch-name-check.yml` does not do this yet.
- Do not add a trigger to a reusable workflow. `devops-architecture/github-workflows-architecture.md` allows triggers only in four door files: `ci.yml` (`pull_request` + `merge_group`), `battery.yml` (nightly `schedule`), `schedule.yml` (`schedule`, long work) and `deploy.yml` (`workflow_dispatch`). The one callable exception is `gitignore-guard.yml`.
- Do not tag a release or push anything from a subagent. Tags are a GitHub action for the main session or the CEO.
- To check workflow syntax, run `actionlint .github/workflows/*.yml`. This is not link-class: it is a fast local lint, not `cargo test`, `docker` or a mutation run, so it needs no `kq-link`. At HEAD it reports two findings: the `github.head_ref` note in `reusable-branch-name-check.yml:10` and shellcheck `SC2034` (unused `i`) in `reusable-ecs-deploy.yml:86`. No CI job runs `actionlint`.

## Branches and how work lands

The law is `kq-board/kq-logic-board/github-environment-rules/branch-classes.md`. It lists `dot-github` (`Kopie-Quant-LLC/.github`) under "Not running right now", because the Pipeline & Quality Loop does not cover it. The table gives branches `main` and `development`, branch today `main`, and work landing on `development`, then, once the loop covers the repo, a PR into `main` that the CEO merges.

The local clone differs from the table. It has `main` (tracking `origin/main`) and no `development` branch, locally or in remote-tracking refs (not re-fetched). Three side branches (`ci/self-hosted-runners`, `ci/terraform-plan-hosted`, `fix/commit-trailer-event-aware`) hold work that is already on `main` through squash merges (inferred from matching subjects, not proven).

Two board pages disagree on this repo. `branch-classes.md` says "Not running right now". `kq-board/kq-logic-board/development-loops/colby/pr-routes/README.md` marks it ACTIVE (CEO, 2026-08-13): topic branch, then PR to `main`, no `development` base. The local branches match the second page. `branch-classes.md` is the newer page (changed 2026-10-04, against 2026-10-03 for `pr-routes`). The CEO decides which one is authoritative.

## Board law and gaps

Pages that govern this repo:

- `kq-board/kq-logic-board/github-environment-rules/README.md`, `branch-classes.md`, `law.md`, `ci-cd-rules.md`
- `kq-board/kq-logic-board/devops-architecture/github-workflows-architecture.md`
- `kq-board/kq-logic-board/development-loops/colby/pr-routes/README.md`
- `kq-board/kq-logic-board/laws/working-with-kq-farm/README.md` (`kq-link` routing for link-class jobs)

The workflows page describes a target state this repo does not contain: `reusable-gate-*` lanes, `reusable-battery`, `reusable-smoke`, `reusable-gitignore-guard`, a `merge_group` trigger in `ci.yml`, and one floating major tag. All of those are planned, not built. `agents-md-header-sync.yml` carries a cron, which that page does not allow outside its named doors.

## Open items

- Whether the `production` GitHub environment has required reviewers is not readable from the repo.
- Whether `kq-knowledge/.kq/AGENTS-CANONICAL-HEADER.md` still exists and matches lines 1–72 is unverified. No local copy exists to diff.
- `terraform-apply` has no producer of its `tfplan` artifact in this repo. A caller must supply it.
- Only the kq root was searched for callers. A repo outside it can call the lanes marked "no caller".

## Identity

- Git Author: the human operator who invoked you. Sun YXZYS is the repo owner.
- Commit Trailer: `Signed-off-by:` from an allow-listed identity, plus `Engineered-By:` (see Commit rules).
- Copyright: Kopie Quant LLC
