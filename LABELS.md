# Kopie-Quant-LLC — Unified GitHub Labels

This document is the catalog of the label set for the Kopie-Quant-LLC organization: 25 labels with exact names, colors and descriptions. The intent is that every repo uses this exact set, so issue tracking and PR triage read the same everywhere.

**How the catalog is applied.** Labels live on GitHub. This repo holds no label-sync file and no workflow that creates or applies these labels, so a person creates them by hand (see "Adding Labels to a New Repo"). Which repos carry the set today is not recorded in code. Read the label list in each repo's GitHub settings to check.

Related files in this repo: the issue templates in `.github/ISSUE_TEMPLATE/` and the repo overview in `README.md`. See `AGENTS.md` for the working rules.

---

## Label Categories

| Category | Count | Purpose |
|----------|-------|---------|
| `priority:` | 4 | Triage urgency for issues and PRs |
| `review:` | 3 | Code review workflow gates |
| `scope:` | 5 | Maps work to a specific service or repo |
| `status:` | 5 | Current lifecycle state of an issue/PR |
| `type:` | 8 | Classifies the nature of the change |
| **Total** | **25** | |

---

## Priority Labels

| Label | Color | Hex | Description |
|-------|-------|-----|-------------|
| `priority: critical` | ![#B60205](https://placehold.co/15x15/B60205/B60205.png) | `#B60205` | Must ship immediately — production impact |
| `priority: high` | ![#D93F0B](https://placehold.co/15x15/D93F0B/D93F0B.png) | `#D93F0B` | Next sprint priority |
| `priority: medium` | ![#FBCA04](https://placehold.co/15x15/FBCA04/FBCA04.png) | `#FBCA04` | Standard priority |
| `priority: low` | ![#C2E0C6](https://placehold.co/15x15/C2E0C6/C2E0C6.png) | `#C2E0C6` | Nice to have, no urgency |

### Usage
- Every issue **must** have exactly one `priority:` label before sprint planning.
- `priority: critical` marks production impact. No workflow in the kq repos notifies Slack when it is applied, so a person must raise the alert.

---

## Review Labels

| Label | Color | Hex | Description |
|-------|-------|-----|-------------|
| `review: lead-dev` | ![#D93F0B](https://placehold.co/15x15/D93F0B/D93F0B.png) | `#D93F0B` | Requires @colbyvk or @YXZYSME review |
| `review: hitl-required` | ![#D93F0B](https://placehold.co/15x15/D93F0B/D93F0B.png) | `#D93F0B` | Human-in-the-loop review required before merge |
| `review: agent-ok` | ![#0E8A16](https://placehold.co/15x15/0E8A16/0E8A16.png) | `#0E8A16` | CI/CD agent validated — human review pending |

### Usage
- `review: agent-ok` is applied by hand. No workflow applies it when checks pass.
- `review: hitl-required` means a human must approve before merge. The label is a convention. No workflow in this repo enforces it.
- `review: lead-dev` means explicit sign-off from a lead developer. Both handles in the description are real code owners. `@colbyvk` owns domain code in `kq-terminal/.github/CODEOWNERS` and `kq-l1-compute-orchestration/.github/CODEOWNERS`. This repo's `.github/CODEOWNERS` names only `@YXZYSME`.

---

## Scope Labels

| Label | Color | Hex | Description |
|-------|-------|-----|-------------|
| `scope: admin-portal` | ![#06D6A0](https://placehold.co/15x15/06D6A0/06D6A0.png) | `#06D6A0` | Relates to kq_admin_portal |
| `scope: infra` | ![#FF6B35](https://placehold.co/15x15/FF6B35/FF6B35.png) | `#FF6B35` | Relates to kq-infra |
| `scope: matchmaking` | ![#118AB2](https://placehold.co/15x15/118AB2/118AB2.png) | `#118AB2` | Relates to kq_matchmaking_engine |
| `scope: shared-lib` | ![#073B4C](https://placehold.co/15x15/073B4C/073B4C.png) | `#073B4C` | Relates to kq_shared_lib |
| `scope: victory-engine` | ![#FFD166](https://placehold.co/15x15/FFD166/FFD166.png) | `#FFD166` | Relates to kq-victory-engine |

### Usage
- Apply `scope:` labels to indicate which service is affected.
- Cross-cutting changes can have multiple `scope:` labels.

### Scope labels against the estate

The descriptions above are the label text this catalog defines. They are not confirmed against any repo's labels on GitHub. The table shows what each name maps to in the current kq root.

| Label | In the kq root today |
|-------|----------------------|
| `scope: infra` | `kq-infra`. The `infra_change` issue template applies this label. |
| `scope: victory-engine` | No `kq-victory-engine` directory in the kq root. Whether the GitHub repo `Kopie-Quant-LLC/kq-victory-engine` still exists is not verified (`agents-md-header-sync.yml` still targets it). The code is the crate `crates/victory-engine` inside `kq-l1-data-engineering`. |
| `scope: admin-portal` | `sites/kq-admin` (GitHub `Kopie-Quant-LLC/kq-admin`), the internal admin console. Its checked-out branch `feat/update-admin-portal` is a frontend prototype on mock data. Its `main` branch still holds a FastAPI backend. The description text `kq_admin_portal` is an old name. |
| `scope: matchmaking` | No `kq_matchmaking_engine` directory exists. Stale name. |
| `scope: shared-lib` | No `kq_shared_lib` directory exists. Stale name. |

No `scope:` label exists for most repos at the kq root, including `kq-terminal`, `kq-core-backend`, `kq-l1-data-engineering`, `kq-l1-compute-orchestration`, `kq-client-management`, `kq-enterprise-portal`, `kq-farm`, `kq-farm-dispatch`, `kq-doc-services`, `kq-development-env`, `kq-product-evaluation`, `kq-board`, `kq-zeus-engine` and `sites/kq-website` (the public site, GitHub `Kopie-Quant-LLC/kq-website`). `sites/kq-admin` is covered by `scope: admin-portal` above. Adding or renaming a scope label is a change to this file, which `.github/CODEOWNERS` assigns to `@YXZYSME`. This file will then change, and the count table at the top must change with it.

---

## Status Labels

| Label | Color | Hex | Description |
|-------|-------|-----|-------------|
| `status: blocked` | ![#D73A4A](https://placehold.co/15x15/D73A4A/D73A4A.png) | `#D73A4A` | Waiting on external dependency or decision |
| `status: do-not-merge` | ![#B60205](https://placehold.co/15x15/B60205/B60205.png) | `#B60205` | PR not ready — do not merge |
| `status: in-progress` | ![#0E8A16](https://placehold.co/15x15/0E8A16/0E8A16.png) | `#0E8A16` | Actively being worked on |
| `status: needs-info` | ![#FBCA04](https://placehold.co/15x15/FBCA04/FBCA04.png) | `#FBCA04` | More information needed from reporter |
| `status: ready-for-review` | ![#0075CA](https://placehold.co/15x15/0075CA/0075CA.png) | `#0075CA` | Ready for code review |

### Usage
- `status: do-not-merge` **must** be applied to any draft or WIP PR. A person applies it. No rule in the repo enforces it.
- `status: blocked` must include a comment that explains the blocker.

---

## Type Labels

| Label | Color | Hex | Description |
|-------|-------|-----|-------------|
| `type: bug` | ![#D73A4A](https://placehold.co/15x15/D73A4A/D73A4A.png) | `#D73A4A` | Something isn't working |
| `type: chore` | ![#BFD4F2](https://placehold.co/15x15/BFD4F2/BFD4F2.png) | `#BFD4F2` | Maintenance or housekeeping |
| `type: ci-cd` | ![#D4C5F9](https://placehold.co/15x15/D4C5F9/D4C5F9.png) | `#D4C5F9` | CI/CD pipeline changes |
| `type: docs` | ![#0075CA](https://placehold.co/15x15/0075CA/0075CA.png) | `#0075CA` | Documentation only |
| `type: feature` | ![#A2EEEF](https://placehold.co/15x15/A2EEEF/A2EEEF.png) | `#A2EEEF` | New feature or request |
| `type: hotfix` | ![#B60205](https://placehold.co/15x15/B60205/B60205.png) | `#B60205` | Critical production fix |
| `type: refactor` | ![#D4C5F9](https://placehold.co/15x15/D4C5F9/D4C5F9.png) | `#D4C5F9` | Code restructuring, no behavior change |
| `type: test` | ![#BFD4F2](https://placehold.co/15x15/BFD4F2/BFD4F2.png) | `#BFD4F2` | Test coverage improvements |

### Usage
- Every issue and PR **must** have exactly one `type:` label.
- `type: hotfix` follows the expedited review process (skip sprint queue).
- The issue templates apply a label on creation: `bug_report` applies `type: bug`, `feature_request` applies `type: feature`, and `infra_change` applies `scope: infra`. All three names are in this set.

---

## Labels outside the 25

The workflow `.github/workflows/agents-md-header-sync.yml` opens issues labelled `agents-md-drift` in the repos it checks. That label is not in the 25-label set and is not counted above. GitHub creates the label on first use if the repo lacks it.

## Repositories Using This Label Set

The earlier table listed `Kopie-Quant-LLC/Production` and `Kopie-Quant-LLC/kq-victory-engine` as synced. Neither is a directory in the kq root, and no code records sync state, so this file no longer claims a repo list. Check each repo's labels page on GitHub.

---

## Adding Labels to a New Repo

1. Navigate to `https://github.com/Kopie-Quant-LLC/<repo>/labels`
2. Delete all 9 default GitHub labels (bug, duplicate, enhancement, good first issue, help wanted, invalid, question, wontfix, documentation)
3. Create all 25 labels from the tables above with the exact names, hex colors, and descriptions

---

> **Maintained by:** Kopie-Quant-LLC Engineering. Code owner for this repo: `@YXZYSME` (`.github/CODEOWNERS`).  
> **Label definitions last changed:** April 5, 2026. Reviewed against the code: October 2026.
