# .github
Public organization profile and community health files for Kopie Quant

## Reusable Workflows Library

Kopie Quant actively maintains a centralized library of reusable GitHub Actions underneath `.github/workflows/`. These templates exist to DRY (Don't Repeat Yourself) the pipelines of our downstream repositories (e.g., `kq-terminal`, `kq-admin`, `kq-forge-engine`).

### 1. Python CI (`reusable-python-ci.yml`)
Standard Python CI gate executing `pip` installations, `ruff` linting, and `pytest`.

**Inputs**:
- `working-directory` (string): Target root. Default `"."`
- `python-version` (string): Python runtime. Default `"3.11"`
- `requirements-file` (string): File for `pip install -r`. Default `"requirements.txt"`
- `pythonpath` (string): Value exported to `PYTHONPATH`. Default `""`
- `run-tests` (boolean): Flag to toggle `pytest`. Default `true`

**Sample Caller**:
```yaml
jobs:
  ci:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-python-ci.yml@main
    with:
      working-directory: kq_terminal
      pythonpath: kq_terminal
```

### 2. Docker Build & Scan (`reusable-docker-build-scan.yml`)
Builds Docker images, optionally pushes them to Amazon ECR, and inherently requires `trivy` vulnerability-scanning success.

**Inputs**:
- `context` (string): Docker build context. Default `"."`
- `dockerfile` (string): Target Dockerfile. Default `"Dockerfile"`
- `image-tag` (string): REQUIRED tag identifier.
- `push` (boolean): Whether to execute pushing. Default `false`
- `ecr-repo` (string): Target ECR repository string.
- `aws-role-arn` (string): OIDC IAM role ARN for auth.
- `aws-region` (string): AWS Region. Default `"us-east-1"`

**Sample Caller**:
```yaml
jobs:
  build:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-docker-build-scan.yml@main
    with:
      image-tag: ${{ github.sha }}
      push: true
      aws-role-arn: arn:aws:iam::123456789012:role/my-role
      ecr-repo: my-app
```

### 3. ECS Deploy (`reusable-ecs-deploy.yml`)
Safely deploys definitions into AWS ECS clusters, correctly handling rendering, zero-capacity parking (`desiredCount=0`), stabilization blocks, rollback capabilities, and health pings based on SSM Parameters.

**Inputs**:
- `aws-role-arn` (string): REQUIRED OIDC role.
- `aws-region` (string): AWS Region. Default `"us-east-1"`
- `cluster` (string): REQUIRED ECS cluster ID.
- `service` (string): REQUIRED ECS service.
- `task-family` (string): REQUIRED task definition family.
- `container-name` (string): REQUIRED internal container name mapping.
- `image` (string): REQUIRED finalized URI to swap logic to.
- `health-url-ssm-param` (string): Optional SSM name holding target URL.

**Sample Caller**:
```yaml
jobs:
  deploy:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-ecs-deploy.yml@main
    with:
      aws-role-arn: arn:aws:iam::123456789012:role/deploy-role
      cluster: my-cluster
      service: my-service
      task-family: my-family
      container-name: backend
      image: 1234.dkr.ecr.us-east-1.amazonaws.com/my-app:123
```

### 4. Terraform Apply (`reusable-terraform-apply.yml`)
Secure continuous deployment runner for downloading pre-compiled Terraform plans and instantiating `terraform apply`.

**Inputs**:
- `working-directory` (string): REQUIRED terraform directory logic path.
- `aws-role-arn` (string): REQUIRED OIDC identity.
- `aws-region` (string): Default `"us-east-1"`.
- `plan-artifact` (string): The artifact name storing `$GITHUB_WORKSPACE`. Default `"tfplan"`
- `terraform-version` (string): Version mapping. Default `"1.9.5"`

**Sample Caller**:
```yaml
jobs:
  cd:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-terraform-apply.yml@main
    with:
      working-directory: environments/prod
      aws-role-arn: arn:aws:iam::123456789012:role/infra-role
```

### 5. Security Scans (`reusable-security.yml`)
Multi-language threat hunting matrix covering hardcoded `gitleaks`, component level `cargo-audit/pip-audit`, and final container scanning via `trivy`.

**Inputs**:
- `language` (string): REQUIRED framework identifier (`'python'`, `'rust'`, `'node'`, `'none'`).
- `working-directory` (string): Default `"."`
- `docker-context` (string): Optional enabler for Trivy scanning.
- `dockerfile` (string): Location of dockerfile target.

**Sample Caller**:
```yaml
jobs:
  security:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-security.yml@main
    with:
      language: python
      working-directory: src/
```

### 6. Branch Name Enforcer (`reusable-branch-name-check.yml`)
Enforces Kopie Quant's native branch syntax methodology (`<type>/<slug>`).

**Sample Caller**:
```yaml
jobs:
  branch-check:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-branch-name-check.yml@main
```

### 7. Commit Trailer Validation (`reusable-commit-trailer.yml`)
Validates that incoming PR commit histories include verifiable human ownership trailers (`Signed-off-by`) and completely lack auto-generated LLM footprint strings (`Co-Authored-By: Claude`). 

**Sample Caller**:
```yaml
jobs:
  signatures:
    uses: Kopie-Quant-LLC/.github/.github/workflows/reusable-commit-trailer.yml@main
```
