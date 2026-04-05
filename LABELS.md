# Kopie-Quant-LLC — Unified GitHub Labels

This document defines the **standardized label system** used across all repositories in the Kopie-Quant-LLC organization. Every repo must use this exact label set to ensure consistency in issue tracking, PR triage, and sprint planning.

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
- `priority: critical` triggers immediate Slack notification to `#kq-alerts`.

---

## Review Labels

| Label | Color | Hex | Description |
|-------|-------|-----|-------------|
| `review: lead-dev` | ![#D93F0B](https://placehold.co/15x15/D93F0B/D93F0B.png) | `#D93F0B` | Requires @colbyvk or @YXZYSME review |
| `review: hitl-required` | ![#D93F0B](https://placehold.co/15x15/D93F0B/D93F0B.png) | `#D93F0B` | Human-in-the-loop review required before merge |
| `review: agent-ok` | ![#0E8A16](https://placehold.co/15x15/0E8A16/0E8A16.png) | `#0E8A16` | CI/CD agent validated — human review pending |

### Usage
- `review: agent-ok` is applied automatically by CI when all checks pass.
- `review: hitl-required` blocks merge until a human approves.
- `review: lead-dev` requires explicit sign-off from a lead developer.

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
- Cross-cutting changes may have multiple `scope:` labels.

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
- `status: do-not-merge` **must** be applied to any draft or WIP PR.
- `status: blocked` should include a comment explaining the blocker.

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

---

## Repositories Using This Label Set

| Repository | Status |
|------------|--------|
| `Kopie-Quant-LLC/Production` | Synced |
| `Kopie-Quant-LLC/kq-victory-engine` | Synced |

---

## Adding Labels to a New Repo

1. Navigate to `https://github.com/Kopie-Quant-LLC/<repo>/labels`
2. Delete all 9 default GitHub labels (bug, duplicate, enhancement, good first issue, help wanted, invalid, question, wontfix, documentation)
3. Create all 25 labels from the tables above with the exact names, hex colors, and descriptions

---

> **Maintained by:** Kopie-Quant-LLC Engineering  
> **Last updated:** April 5, 2026
