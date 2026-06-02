## Overview
Organization-wide shared defaults for GitHub. It includes issue template configurations, reusable Actions workflow files, and base community guidelines.

## Architecture
- **.github/workflows/**: Reusable files for Docker packaging, ECS deploys, and security checking.
- **ISSUE_TEMPLATE/**: Templates ensuring bugs and tasks are scoped.

## Getting Started
Prerequisites: Git
Install: Clone to explore workflows. No setup required.

## Testing
Validate GitHub Actions yaml formatting:
```bash
actionlint .github/workflows/*.yml
```

## Deployment
Changes committed directly to the `main` branch to update organization settings.

## Team
- **Owner:** `kq-sre`
- **Escalation Path:** Sun YXZYS (CTO)

## Related Repos
- All Kopie-Quant-LLC repositories (pull reusable workflows from here).
