# Architecture Quick Reference

## 🏗️ System Overview

**Architecture**: AWS ECS Fargate + ALB + CloudWatch  
**Deployment**: GitHub Actions + OIDC  
**Monitoring**: CloudWatch + SNS  
**Security**: VPC + IAM + Secrets Manager  
**Cost**: AWS Free Tier Compliant  

## 📊 Key Metrics

| Metric | Value |
|--------|-------|
| **Response Time** | < 200ms |
| **Availability** | 99.9%+ |
| **Auto-scaling** | 1-10 tasks |
| **Free Tier** | $0-5/month |
| **Deployment Time** | ~5 minutes |

## 🔗 Quick Links

### Application Endpoints
- **Main App**: `http://YOUR_ALB_DNS/`
- **Health Check**: `http://YOUR_ALB_DNS/health`
- **API Status**: `http://YOUR_ALB_DNS/api`
- **Readiness**: `http://YOUR_ALB_DNS/ready`
- **Liveness**: `http://YOUR_ALB_DNS/live`

### AWS Console Links
- **ECS Cluster**: [ECS Console](https://console.aws.amazon.com/ecs/)
- **CloudWatch Dashboard**: [CloudWatch](https://console.aws.amazon.com/cloudwatch/)
- **ECR Repository**: [ECR Console](https://console.aws.amazon.com/ecr/)
- **Load Balancer**: [ALB Console](https://console.aws.amazon.com/ec2/v2/home#LoadBalancers)

### GitHub Actions
- **Workflow**: `.github/workflows/deploy-ecs.yml`
- **OIDC Role**: `takehome-github-actions-role`
- **ECR Repository**: `takehome-app`

## 🛠️ Common Commands

### Health Check
```bash
# Local testing
./scripts/health-check.sh http://localhost:3000

# Production testing
./scripts/health-check.sh http://YOUR_ALB_DNS
```

### Terraform Operations
```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy (careful!)
terraform destroy
```

### AWS CLI Commands
```bash
# Get ALB DNS
aws elbv2 describe-load-balancers --names takehome-eks-alb --query 'LoadBalancers[0].DNSName' --output text

# Check ECS service
aws ecs describe-services --cluster takehome-eks --services takehome-eks-service

# View logs
aws logs tail /ecs/takehome-eks --follow
```

### Docker Commands
```bash
# Build locally
docker build -t devops-app .

# Run locally
docker run -p 3000:3000 devops-app

# Test health
curl http://localhost:3000/health
```

## 📁 File Structure

```
devops_task/
├── terraform/                 # Infrastructure as Code
│   ├── modules/              # Terraform modules
│   │   ├── ecs/             # ECS Fargate
│   │   ├── ecr/             # Container registry
│   │   ├── monitoring/      # CloudWatch
│   │   ├── secrets/         # Secrets Manager
│   │   ├── https/           # HTTPS/TLS
│   │   └── github_oidc/     # GitHub OIDC
│   ├── main.tf              # Root configuration
│   └── variables.tf         # Input variables
├── .github/workflows/        # CI/CD Pipeline
│   └── deploy-ecs.yml       # GitHub Actions
├── scripts/                  # Utility scripts
│   ├── health-check.sh      # Health validation
│   └── curl-format.txt      # Performance testing
├── docs/                     # Documentation
│   ├── architecture-diagrams.md
│   ├── diagram-generation-guide.md
│   └── architecture-quick-reference.md
├── app/public/               # Static content
│   └── index.html           # Landing page
├── index.js                  # Node.js application
├── Dockerfile               # Container definition
├── package.json             # Dependencies
└── README.md                # Complete documentation
```

## 🚨 Troubleshooting

### Common Issues

#### 504 Gateway Timeout
- **Cause**: Port mismatch between ALB and ECS
- **Fix**: Check ALB target group port (should be 3000)
- **Command**: `aws elbv2 describe-target-groups --names takehome-eks-tg`

#### 503 Service Unavailable
- **Cause**: ECS service not running or unhealthy
- **Fix**: Check ECS service status and task health
- **Command**: `aws ecs describe-services --cluster takehome-eks --services takehome-eks-service`

#### OIDC Authentication Failed
- **Cause**: GitHub repository not in trust policy
- **Fix**: Update IAM role trust policy
- **Command**: `aws iam get-role --role-name takehome-github-actions-role`

#### Health Check Failed
- **Cause**: Application not responding on health endpoint
- **Fix**: Check application logs and health endpoint
- **Command**: `aws logs tail /ecs/takehome-eks --follow`

### Debug Commands

```bash
# Check all resources
terraform show

# Check ECS tasks
aws ecs list-tasks --cluster takehome-eks

# Check ALB targets
aws elbv2 describe-target-health --target-group-arn $(aws elbv2 describe-target-groups --names takehome-eks-tg --query 'TargetGroups[0].TargetGroupArn' --output text)

# Check CloudWatch alarms
aws cloudwatch describe-alarms --alarm-names takehome-eks-high-cpu takehome-eks-high-memory
```

## 📈 Monitoring

### Key Metrics to Watch
- **CPU Utilization**: Should be < 80%
- **Memory Utilization**: Should be < 80%
- **Request Count**: Monitor traffic patterns
- **Response Time**: Should be < 200ms
- **Error Rate**: Should be < 1%

### Alert Thresholds
- **High CPU**: > 80% for 5 minutes
- **High Memory**: > 80% for 5 minutes
- **High Error Rate**: > 5% for 2 minutes
- **Low Request Count**: < 1 request per minute for 10 minutes

## 🔒 Security

### Security Groups
- **ALB**: Inbound 80/443 from 0.0.0.0/0
- **ECS**: Inbound 3000 from ALB security group
- **Outbound**: All traffic to 0.0.0.0/0

### IAM Roles
- **GitHub Actions**: ECR, ECS, IAM permissions
- **ECS Task**: CloudWatch, Secrets Manager permissions
- **ECS Execution**: ECR, CloudWatch permissions

### Secrets
- **Database URL**: `app/database-url`
- **API Key**: `app/api-key`
- **Rotation**: 30-day rotation enabled

## 💰 Cost Optimization

### Free Tier Limits
- **ECS Fargate**: 20 GB-hours/month
- **ALB**: 750 hours/month
- **ECR**: 500 MB storage/month
- **CloudWatch**: 10 metrics, 5 GB logs/month

### Cost Monitoring
- **Budget Alert**: $10/month
- **Cost Explorer**: Monthly reports
- **Optimization**: Fargate Spot for non-critical workloads

## 🚀 Deployment

### Manual Deployment
```bash
# Build and push image
docker build -t takehome-app .
docker tag takehome-app:latest YOUR_ECR_URI:latest
docker push YOUR_ECR_URI:latest

# Update ECS service
aws ecs update-service --cluster takehome-eks --service takehome-eks-service --force-new-deployment
```

### Automated Deployment
- **Trigger**: Push to main/develop branch
- **Pipeline**: GitHub Actions
- **Duration**: ~5 minutes
- **Health Checks**: Automatic validation

## 📞 Support

### Documentation
- **README**: Complete setup guide
- **Architecture**: Detailed diagrams
- **Troubleshooting**: Common issues and fixes

### Monitoring
- **CloudWatch**: Real-time metrics
- **GitHub Actions**: Deployment logs
- **Health Checks**: Application status

### Emergency Contacts
- **AWS Support**: [AWS Support Center](https://console.aws.amazon.com/support/)
- **GitHub Issues**: [Repository Issues](https://github.com/iwishiwala/devops_task/issues)
- **Documentation**: [Project README](README.md)
