# Pipeline Guide

This guide explains the optimized CI/CD pipeline behavior and how to use it effectively.

## 🚀 Pipeline Overview

The project now uses **two separate pipelines** for optimal efficiency:

1. **Application Deployment Pipeline** (`deploy-ecs.yml`)
2. **Infrastructure Pipeline** (`infrastructure.yml`)

## 📁 File Triggers

### Application Deployment Pipeline
**Triggers on changes to:**
- `index.js` - Main application code
- `package.json` / `package-lock.json` - Dependencies
- `Dockerfile` / `.dockerignore` - Container configuration
- `app/**` - Application assets and static files
- `.github/workflows/deploy-ecs.yml` - Pipeline itself

### Infrastructure Pipeline
**Triggers on changes to:**
- `terraform/**` - All Terraform configuration files
- `.github/workflows/infrastructure.yml` - Pipeline itself

### No Pipeline Trigger
**These changes will NOT trigger any deployment:**
- `README.md` - Documentation
- `docs/**` - Documentation files
- `scripts/**` - Utility scripts (unless they affect deployment)
- `.gitignore` - Git configuration
- Other non-application files

## 🔄 Workflow Types

### 1. Application Deployment (`deploy-ecs.yml`)

#### **Automatic Trigger**
- **When**: Push/PR with application file changes
- **What**: Builds Docker image, pushes to ECR, deploys to ECS
- **Duration**: ~5-8 minutes
- **Health Checks**: Comprehensive validation

#### **Manual Trigger**
- **Access**: GitHub Actions → Deploy to ECS → Run workflow
- **Options**:
  - **Force Deploy**: Bypass path filters (emergency deployments)
  - **Branch**: Select target branch
- **Use Cases**:
  - Emergency deployments
  - Testing new features
  - Rollback scenarios

### 2. Infrastructure Pipeline (`infrastructure.yml`)

#### **Automatic Trigger**
- **When**: Push/PR with Terraform file changes
- **What**: Terraform plan (preview changes)
- **Duration**: ~2-3 minutes
- **Safety**: Only plans, doesn't apply

#### **Manual Trigger**
- **Access**: GitHub Actions → Infrastructure Changes → Run workflow
- **Options**:
  - **Terraform Action**: plan, apply, destroy
  - **Auto-approve**: Skip confirmation prompts
  - **Branch**: Select target branch
- **Use Cases**:
  - Apply infrastructure changes
  - Emergency infrastructure updates
  - Cleanup/destroy resources

## 🎯 Best Practices

### Application Development
1. **Make Changes**: Edit application files (`index.js`, `package.json`, etc.)
2. **Commit & Push**: Standard git workflow
3. **Monitor**: Watch GitHub Actions for deployment progress
4. **Verify**: Check application health after deployment

### Infrastructure Changes
1. **Make Changes**: Edit Terraform files in `terraform/`
2. **Commit & Push**: Standard git workflow
3. **Review Plan**: Check the automatic Terraform plan
4. **Apply Changes**: Use manual trigger if plan looks good
5. **Monitor**: Watch for any infrastructure issues

### Documentation Updates
1. **Make Changes**: Edit `README.md`, `docs/`, etc.
2. **Commit & Push**: Standard git workflow
3. **No Deployment**: No CI/CD pipeline will run
4. **Efficiency**: Saves CI/CD minutes and resources

## 🚨 Emergency Procedures

### Force Application Deployment
```bash
# If you need to deploy without changing application files
# 1. Go to GitHub Actions
# 2. Click "Deploy to ECS"
# 3. Click "Run workflow"
# 4. Check "Force deployment"
# 5. Click "Run workflow"
```

### Emergency Infrastructure Changes
```bash
# For urgent infrastructure updates
# 1. Go to GitHub Actions
# 2. Click "Infrastructure Changes"
# 3. Click "Run workflow"
# 4. Select "apply" action
# 5. Check "Auto-approve" if needed
# 6. Click "Run workflow"
```

### Rollback Application
```bash
# If deployment fails or issues occur
# 1. Go to GitHub Actions
# 2. Click "Deploy to ECS"
# 3. Click "Run workflow"
# 4. Select previous working commit
# 5. Check "Force deployment"
# 6. Click "Run workflow"
```

## 📊 Pipeline Status

### Check Pipeline Status
1. **GitHub Actions**: [Actions Tab](https://github.com/iwishiwala/devops_task/actions)
2. **Recent Runs**: Check latest workflow runs
3. **Logs**: Click on any run to see detailed logs
4. **Status**: Green = Success, Red = Failed, Yellow = Running

### Common Status Indicators
- ✅ **Success**: Deployment completed successfully
- ❌ **Failed**: Check logs for error details
- 🟡 **Running**: Pipeline is currently executing
- ⏭️ **Skipped**: No relevant changes detected

## 🔧 Troubleshooting

### Pipeline Not Triggering
**Problem**: Changes made but no pipeline runs
**Solution**: Check if files are in the trigger paths
- Application changes: `index.js`, `package.json`, `Dockerfile`, `app/**`
- Infrastructure changes: `terraform/**`
- Documentation changes: No pipeline (by design)

### Pipeline Failing
**Problem**: Pipeline runs but fails
**Solution**: Check the logs
1. Go to GitHub Actions
2. Click on the failed run
3. Expand the failed step
4. Check error messages
5. Fix the issue and push again

### Force Deployment Not Working
**Problem**: Force deployment option not available
**Solution**: Ensure you have the right permissions
1. Check repository permissions
2. Ensure you're on the correct branch
3. Try refreshing the GitHub Actions page

## 📈 Performance Benefits

### Resource Savings
- **CI/CD Minutes**: Only runs when needed
- **AWS Costs**: Avoids unnecessary deployments
- **Developer Time**: Faster feedback on relevant changes

### Efficiency Gains
- **Focused Deployments**: Only application changes trigger deployments
- **Infrastructure Safety**: Separate pipeline for infrastructure changes
- **Documentation Freedom**: Update docs without triggering deployments

### Monitoring Benefits
- **Clear Triggers**: Easy to understand what triggers what
- **Focused Alerts**: Only get notified for relevant changes
- **Better Debugging**: Easier to trace issues to specific changes

## 🎓 Learning Resources

### GitHub Actions
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Path Filters](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpaths)

### Terraform
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

### ECS
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [ECS Best Practices](https://docs.aws.amazon.com/ecs/latest/bestpracticesguide/)
- [Fargate Pricing](https://aws.amazon.com/fargate/pricing/)

This optimized pipeline approach ensures efficient resource usage while maintaining the flexibility to deploy when needed!
