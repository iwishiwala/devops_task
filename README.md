# GitHub Actions Setup for ECS Deployment

This document explains how to set up GitHub Actions to deploy your application to AWS ECS using OIDC authentication.

## Prerequisites

1. AWS infrastructure deployed via Terraform
2. GitHub repository with the workflow files
3. GitHub repository secrets configured

## Required GitHub Secrets

After running `terraform apply`, you'll need to set up the following GitHub repository secrets:

### 1. AWS_ROLE_ARN

This is the ARN of the IAM role that GitHub Actions will assume. You can get this value from the Terraform outputs:

```bash
terraform output github_actions_role_arn
```

Set this as a GitHub repository secret named `AWS_ROLE_ARN`.

### 2. Optional: Environment-specific secrets

You may want to add additional secrets for:
- `NODE_ENV` (defaults to "production")
- Any application-specific environment variables

## Setting up GitHub Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add the secrets listed above

## Workflow Triggers

The GitHub Actions workflow will trigger on:
- Push to `main` or `develop` branches
- Pull requests to `main` branch

## Workflow Steps

1. **Checkout**: Downloads the repository code
2. **Configure AWS credentials**: Uses OIDC to assume the IAM role
3. **Login to ECR**: Authenticates with Amazon Elastic Container Registry
4. **Build and push image**: Builds Docker image and pushes to ECR
5. **Update task definition**: Updates the ECS task definition with new image
6. **Deploy to ECS**: Deploys the updated task definition to ECS service
7. **Get service URL**: Retrieves the ALB DNS name for the deployed service
8. **Comment on PR**: Adds deployment information to pull request comments

## ECR Repository

The workflow uses an ECR repository named `takehome-app` which is created by Terraform. The repository includes:
- Image scanning on push
- Lifecycle policies to manage image retention
- Proper IAM permissions for GitHub Actions

## Troubleshooting

### Common Issues

1. **Permission denied**: Ensure the GitHub Actions role has the correct permissions
2. **ECR login failed**: Check that the ECR repository exists and is accessible
3. **ECS deployment failed**: Verify the task definition and service configuration
4. **Load balancer not found**: Ensure the ALB is created and has the correct name

### Debugging

To debug issues:
1. Check the GitHub Actions logs for detailed error messages
2. Verify AWS resources exist using the AWS CLI
3. Check CloudWatch logs for ECS service issues
4. Ensure all required IAM permissions are granted

## Security Notes

- The OIDC configuration is restricted to the specific repository and branch
- IAM permissions follow the principle of least privilege
- ECR images are scanned for vulnerabilities
- Secrets are encrypted and only accessible to the workflow
