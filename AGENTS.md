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

> This repo holds reusable GitHub Actions workflows consumed by all
> working repos in the Kopie-Quant-LLC organization.

## This Repository

- **Lane:** Sun (infrastructure)
- **Stack:** GitHub Actions YAML
- **Purpose:** Centralized reusable CI/CD workflows, Dependabot config,
  CODEOWNERS, and org-level automation (AGENTS.md drift detection)

## Reusable Workflows

| Workflow | Purpose |
|---|---|
| `reusable-commit-trailer.yml` | Validate commit sign-off trailers |
| `reusable-docker-build-scan.yml` | Build + Trivy scan Docker images |
| `reusable-ecs-deploy.yml` | ECS Fargate blue/green deploy |
| `reusable-node-ci.yml` | Node.js lint + test + build |
| `reusable-python-ci.yml` | Python lint + test |
| `reusable-rust-ci.yml` | Rust fmt + clippy + test |
| `reusable-security.yml` | Trivy + tfsec + secret scanning |
| `reusable-static-cloudfront.yml` | S3 sync + CloudFront invalidation |
| `reusable-terraform-plan.yml` | Terraform plan with PR comment |
| `reusable-terraform-apply.yml` | Terraform apply with approval gate |
| `reusable-branch-name-check.yml` | Validate branch naming convention |
| `agents-md-header-sync.yml` | AGENTS.md canonical header drift detection |

## Identity

- Git Author: `Sun YXZYS`
- Commit Trailer: `Signed-off-by: Sun YXZYS`
- Copyright: Kopie Quant LLC
