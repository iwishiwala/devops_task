# GitHub OIDC Module

This Terraform module creates AWS IAM resources for GitHub Actions OIDC authentication. It's designed to be generic and work with any repository and AWS account.

## Features

- **Auto-detection**: Automatically detects GitHub repository from git remote
- **Multi-branch support**: Supports multiple branches (main, develop, etc.)
- **Generic**: Works with any AWS account and GitHub repository
- **Comprehensive permissions**: Includes ECR, ECS, IAM, ELB, and CloudWatch permissions

## Usage

### Basic Usage (Auto-detection)

```hcl
module "github_oidc" {
  source = "./modules/github_oidc"
  
  # Repository will be auto-detected from git remote
  # Branches default to ["main", "develop"]
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Advanced Usage (Manual configuration)

```hcl
module "github_oidc" {
  source = "./modules/github_oidc"
  
  # Override auto-detection
  github_repo = "myorg/myrepo"
  
  # Custom branches
  github_branches = ["main", "develop", "staging"]
  
  # Custom role name
  role_name = "my-custom-github-role"
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| role_name | Name of the IAM role for GitHub Actions | `string` | `"github-actions"` | no |
| github_repo | GitHub repository in format 'org/repo'. If empty, auto-detects from git remote | `string` | `""` | no |
| github_branches | List of branches that can assume the role | `list(string)` | `["main", "develop"]` | no |
| tags | A map of tags to add to the resources created | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | IAM Role ARN for GitHub Actions |
| github_actions_role_arn | GitHub Actions IAM Role ARN |
| oidc_provider_arn | OIDC Provider ARN for GitHub |
| github_repo | GitHub repository that was detected or configured |
| github_branches | GitHub branches that can assume the role |

## GitHub Actions Setup

1. **Set the GitHub Secret**:
   - Go to your repository Settings → Secrets and variables → Actions
   - Add a new repository secret:
     - Name: `AWS_ROLE_ARN`
     - Value: Use the output `github_actions_role_arn`

2. **Use in GitHub Actions Workflow**:
   ```yaml
   - name: Configure AWS credentials
     uses: aws-actions/configure-aws-credentials@v4
     with:
       role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
       aws-region: us-east-1
   ```

## Permissions

The created IAM role includes permissions for:

- **ECR**: Push/pull images, manage repositories
- **ECS**: Deploy services, manage tasks
- **IAM**: Pass roles to ECS tasks
- **ELB**: Describe load balancers and target groups
- **CloudWatch**: Create and manage logs

## Auto-detection

The module automatically detects your GitHub repository by:
1. Running `git remote get-url origin`
2. Extracting the repository name from the URL
3. Supporting both HTTPS and SSH URLs

If auto-detection fails, you can manually specify the repository using the `github_repo` variable.

## Multi-branch Support

The trust policy supports multiple branches by creating separate conditions for each branch:
- `repo:org/repo:ref:refs/heads/main`
- `repo:org/repo:ref:refs/heads/develop`
- etc.

This allows GitHub Actions to work from any of the specified branches.
