---
name: 🏗️ Infra Change
about: Propose an infrastructure or DevOps change
title: "[INFRA] "
labels: "scope: infra"
assignees: "YXZYSME"
---

## Change Description
<!-- What infrastructure change is being proposed? -->

## AWS Services Impacted
<!-- List every AWS service affected by this change. -->
| Service | Current State | Proposed State |
|---------|--------------|----------------|
| <!-- e.g., ECS --> | <!-- e.g., 2 tasks, t3.medium --> | <!-- e.g., 4 tasks, c6g.xlarge --> |

## Estimated Cost Delta
<!-- Monthly cost impact. Use AWS Pricing Calculator if needed. -->
- **Current monthly cost:** $
- **Projected monthly cost:** $
- **Delta:** +/- $

## Security Impact
<!-- Does this change affect network boundaries, IAM roles, secrets, or compliance posture? -->

## Rollback Plan
<!-- How do we revert this change if it fails? -->
1. 
2. 
3. 

## Compliance Impact
<!-- Does this affect SEC 17a-4 audit trails, data residency, or encryption at rest? -->
- [ ] No compliance impact
- [ ] Requires compliance review before merge

## Testing Plan
<!-- How will this infra change be verified before production? -->
- [ ] Tested in staging environment
- [ ] Dry run completed
- [ ] Monitoring/alerting updated

## Additional Context
<!-- Architecture diagrams, Terraform plan output, etc. -->
