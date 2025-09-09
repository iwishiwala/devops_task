# DevOps Takehome - Complete AWS ECS Deployment

This project demonstrates a complete DevOps pipeline with AWS ECS Fargate, including monitoring, logging, secrets management, and CI/CD with GitHub Actions.

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│  GitHub Actions  │───▶│   AWS ECR       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  CloudWatch     │◀───│   AWS ECS        │◀───│   AWS ALB       │
│  Monitoring     │    │   Fargate        │    │   (HTTPS/HTTP)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │ AWS Secrets      │
                       │ Manager          │
                       └──────────────────┘
```

## 🚀 Features

### Core Features
- **Container Orchestration**: AWS ECS Fargate with auto-scaling
- **Load Balancing**: Application Load Balancer with health checks
- **Container Registry**: AWS ECR with lifecycle policies
- **Networking**: VPC with public/private subnets and NAT Gateway
- **CI/CD**: GitHub Actions with OIDC authentication
- **Monitoring**: CloudWatch dashboards and alarms
- **Logging**: Centralized logging with CloudWatch Logs
- **Secrets Management**: AWS Secrets Manager integration

### Bonus Features
- **HTTPS/TLS**: SSL certificates with AWS Certificate Manager
- **Blue-Green Deployments**: ECS service updates with zero downtime
- **Health Checks**: Custom application health endpoints
- **Alerting**: Email and Slack notifications
- **Auto-Detection**: Automatic GitHub repository detection

## 📋 Prerequisites

### AWS Account Setup
1. **Create AWS Account**: Sign up at [aws.amazon.com](https://aws.amazon.com)
2. **Configure AWS CLI**: 
   ```bash
   aws configure
   # Enter your Access Key ID, Secret Access Key, and region (us-east-1)
   ```
3. **Verify Permissions**: Ensure your AWS user has the following permissions:
   - ECS (Full access)
   - ECR (Full access)
   - VPC (Full access)
   - IAM (Full access)
   - CloudWatch (Full access)
   - SNS (Full access)
   - Secrets Manager (Full access)
   - Certificate Manager (Full access)
   - Route53 (if using custom domain)

### GitHub Setup
1. **Fork this repository** to your GitHub account
2. **Clone the repository**:
   ```bash
   git clone https://github.com/iwishiwala/devops_task.git
   cd devops_task
   ```

### Local Development
1. **Install Node.js** (v18 or later):
   ```bash
   # macOS
   brew install node
   
   # Ubuntu/Debian
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Test locally**:
   ```bash
   npm start
   # Visit http://localhost:3000
   ```

## 🛠️ Deployment Instructions

### Step 1: Configure Terraform Variables

1. **Navigate to terraform directory**:
   ```bash
   cd terraform
   ```

2. **Update variables** (optional):
   ```bash
   # Edit terraform/variables.tf to customize:
   # - cluster_name
   # - aws_region
   # - notification_email (for alerts)
   ```

### Step 2: Deploy Infrastructure

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan deployment**:
   ```bash
   terraform plan
   ```

3. **Deploy infrastructure**:
   ```bash
   terraform apply
   ```

4. **Note the outputs**:
   ```bash
   terraform output
   # Save the github_actions_role_arn for GitHub setup
   ```

### Step 3: Configure GitHub Secrets

1. **Go to your GitHub repository**
2. **Navigate to Settings → Secrets and variables → Actions**
3. **Add the following secrets**:
   - `AWS_ROLE_ARN`: Use the `github_actions_role_arn` from terraform output
   - `AWS_REGION`: `us-east-1` (or your preferred region)

### Step 4: Configure Monitoring (Optional)

1. **Set up email alerts**:
   ```bash
   # Edit terraform/main.tf
   # Uncomment and set notification_email in monitoring module
   ```

2. **Set up Slack alerts** (optional):
   ```bash
   # Add slack_webhook_url to monitoring module
   # Get webhook URL from Slack app settings
   ```

### Step 5: Deploy Application

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Initial deployment"
   git push origin develop
   ```

2. **Monitor deployment**:
   - Check GitHub Actions tab for deployment progress
   - Monitor CloudWatch dashboard for metrics
   - Check ECS console for service status

### Step 6: Access Application

1. **Get the ALB URL**:
   ```bash
   terraform output alb_dns_name
   ```

2. **Visit the application**:
   - HTTP: `http://YOUR_ALB_DNS_NAME`
   - Health check: `http://YOUR_ALB_DNS_NAME/health`
   - API endpoint: `http://YOUR_ALB_DNS_NAME/api`

## 🔧 Configuration Options

### Custom Domain with HTTPS

1. **Update terraform/main.tf**:
   ```hcl
   module "https" {
     source = "./modules/https"
     
     domain_name        = "your-domain.com"
     alb_arn           = module.ecs.alb_arn
     alb_listener_arn  = module.ecs.alb_listener_arn
     target_group_arn  = module.ecs.target_group_arn
   }
   ```

2. **Configure Route53**:
   - Ensure your domain is managed by Route53
   - Or create a hosted zone for your domain

### Custom Secrets

1. **Update terraform/main.tf**:
   ```hcl
   module "secrets" {
     source = "./modules/secrets"
     
     secrets = {
       "app/database-url" = {
         description = "Database connection URL"
         value       = "postgresql://user:password@host:5432/db"
       }
       "app/api-key" = {
         description = "External API key"
         value       = "your-secret-key"
       }
     }
   }
   ```

### Blue-Green Deployments

The ECS service is configured for blue-green deployments:
- New task definitions are created with each deployment
- ECS automatically manages the transition
- Zero-downtime deployments
- Automatic rollback on failure

### Health Checks & Validation

The GitHub Actions pipeline includes comprehensive health checks:

#### **Application Health Checks**
- **Basic Connectivity**: Tests if the application is reachable
- **Health Endpoint**: Validates `/health` endpoint returns `healthy` status
- **Readiness Check**: Tests `/ready` endpoint for service readiness
- **API Endpoint**: Validates `/api` endpoint functionality

#### **Infrastructure Health Checks**
- **Load Balancer Target Health**: Verifies ALB target group health
- **ECS Service Status**: Checks service is ACTIVE with correct task count
- **Performance Test**: Measures response time and concurrent request handling

#### **Health Check Endpoints**
- `GET /health`: Comprehensive health status with memory usage
- `GET /ready`: Readiness check for service dependencies
- `GET /live`: Liveness check for container health
- `GET /api`: API status and service information

#### **Automated Validation**
- Health checks run automatically after each deployment
- Pipeline fails if any health check fails
- Detailed logging and error reporting
- Performance metrics collection

## 📊 Monitoring and Alerting

### CloudWatch Dashboard
- **CPU and Memory utilization**
- **Request count and response times**
- **Target group health**
- **Application logs**

### Alarms
- **High CPU utilization** (>80%)
- **High memory utilization** (>85%)
- **High error rate** (>10 5XX errors)
- **Unhealthy hosts** (any unhealthy targets)
- **Low request count** (potential service down)

### Logs
- **Application logs**: `/aws/ecs/CLUSTER_NAME/application`
- **ECS logs**: `/aws/ecs/CLUSTER_NAME`
- **ALB logs**: Available in S3 (if enabled)

## 🔒 Security Features

### IAM Roles
- **Least privilege access**
- **OIDC authentication** for GitHub Actions
- **Secrets access** for ECS tasks
- **No hardcoded credentials**

### Network Security
- **Private subnets** for ECS tasks
- **Security groups** with minimal required access
- **NAT Gateway** for outbound internet access

### Secrets Management
- **AWS Secrets Manager** for sensitive data
- **Encryption at rest**
- **Automatic rotation** (configurable)

## 🚨 Troubleshooting

### Common Issues

1. **OIDC Authentication Failed**:
   ```bash
   # Check GitHub repository name matches
   terraform output github_repo
   
   # Verify GitHub secret is set correctly
   # Check IAM role trust policy
   ```

2. **ECS Service Not Starting**:
   ```bash
   # Check ECS service events
   aws ecs describe-services --cluster CLUSTER_NAME --services SERVICE_NAME
   
   # Check task definition
   aws ecs describe-task-definition --task-definition TASK_DEFINITION
   ```

3. **Health Check Failures**:
   ```bash
   # Check target group health
   aws elbv2 describe-target-health --target-group-arn TARGET_GROUP_ARN
   
   # Check application logs
   aws logs tail /aws/ecs/CLUSTER_NAME/application --follow
   ```

4. **High Costs**:
   ```bash
   # Check resource usage
   aws cloudwatch get-metric-statistics --namespace AWS/ECS --metric-name CPUUtilization
   
   # Consider reducing desired count or instance size
   ```

### Useful Commands

```bash
# Check ECS service status
aws ecs describe-services --cluster takehome-eks --services takehome-eks-service

# View application logs
aws logs tail /aws/ecs/takehome-eks/application --follow

# Check ALB target health
aws elbv2 describe-target-health --target-group-arn $(terraform output -raw target_group_arn)

# Force new deployment
aws ecs update-service --cluster takehome-eks --service takehome-eks-service --force-new-deployment
```

## 📈 Scaling and Optimization

### Auto Scaling
- **ECS Service Auto Scaling** (configured in terraform)
- **Target tracking** based on CPU/memory
- **Scheduled scaling** for predictable workloads

### Cost Optimization
- **Fargate Spot** for non-critical workloads
- **Right-sizing** based on actual usage
- **Reserved capacity** for predictable workloads
- **Lifecycle policies** for ECR images

### Performance Tuning
- **Container optimization** (multi-stage builds)
- **Log level configuration**
- **Health check optimization**
- **Connection pooling**

## 🧪 Testing

### Local Testing
```bash
# Run tests
npm test

# Test health endpoint
curl http://localhost:3000/health

# Test API endpoint
curl http://localhost:3000/api
```

### Integration Testing
```bash
# Test ALB endpoint
curl http://YOUR_ALB_DNS_NAME/health

# Test with load
for i in {1..10}; do curl http://YOUR_ALB_DNS_NAME/api; done

# Use the health check script
./scripts/health-check.sh http://YOUR_ALB_DNS_NAME
```

### Health Check Script
A comprehensive health check script is provided for testing:

```bash
# Test local application
./scripts/health-check.sh http://localhost:3000

# Test deployed application
./scripts/health-check.sh http://YOUR_ALB_DNS_NAME

# Test with default localhost
./scripts/health-check.sh
```

The script tests:
- ✅ Basic connectivity
- ✅ Health endpoint (`/health`)
- ✅ Readiness endpoint (`/ready`)
- ✅ Liveness endpoint (`/live`)
- ✅ API endpoint (`/api`)
- ✅ JSON response validation

## 📚 Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [CloudWatch Monitoring](https://docs.aws.amazon.com/cloudwatch/)

## 🚀 Future Scope & Enhancements

### **Immediate Enhancements**
- **HTTPS/TLS Support**: SSL certificates with custom domains using AWS Certificate Manager
- **Blue-Green Deployments**: Advanced deployment strategies with traffic shifting
- **Multi-Environment**: Support for staging, production, and development environments
- **Database Integration**: RDS PostgreSQL or DynamoDB for persistent data storage
- **Caching Layer**: ElastiCache Redis for improved performance

### **Advanced Monitoring & Observability**
- **Distributed Tracing**: AWS X-Ray for request tracing across services
- **Custom Metrics**: Application-specific CloudWatch metrics
- **Log Aggregation**: Centralized logging with ELK stack or similar
- **APM Integration**: New Relic, DataDog, or similar APM tools
- **Synthetic Monitoring**: Automated testing with AWS Synthetics

### **Security Enhancements**
- **WAF Integration**: AWS Web Application Firewall for DDoS protection
- **Secrets Rotation**: Automatic secret rotation with AWS Secrets Manager
- **VPC Flow Logs**: Network traffic monitoring and analysis
- **Security Scanning**: Container vulnerability scanning with ECR
- **Compliance**: SOC2, PCI-DSS compliance frameworks

### **Performance & Scalability**
- **Auto Scaling**: Advanced auto-scaling policies based on custom metrics
- **CDN Integration**: CloudFront for global content delivery
- **Database Optimization**: Read replicas, connection pooling
- **Microservices**: Service mesh with AWS App Mesh
- **Event-Driven Architecture**: SQS, SNS, EventBridge integration

### **DevOps & CI/CD Improvements**
- **Multi-Region Deployment**: Cross-region disaster recovery
- **GitOps**: ArgoCD or Flux for Git-based deployments
- **Infrastructure Testing**: Terratest for infrastructure validation
- **Security Scanning**: SAST/DAST integration in CI/CD pipeline
- **Deployment Strategies**: Canary, A/B testing deployments

### **Cost Optimization**
- **Spot Instances**: Fargate Spot for non-critical workloads
- **Reserved Capacity**: Cost savings for predictable workloads
- **Resource Right-Sizing**: Automated resource optimization
- **Cost Monitoring**: AWS Cost Explorer and Budget alerts
- **FinOps Practices**: Cost allocation and chargeback

### **Advanced Features**
- **API Gateway**: REST API management and throttling
- **Service Discovery**: AWS Cloud Map for service discovery
- **Message Queues**: SQS for asynchronous processing
- **Event Streaming**: Kinesis for real-time data processing
- **Machine Learning**: SageMaker integration for ML workloads

### **Enterprise Features**
- **Multi-Account**: AWS Organizations and cross-account access
- **Compliance**: Automated compliance checking and reporting
- **Backup & DR**: Cross-region backup and disaster recovery
- **Audit Logging**: CloudTrail and Config for audit trails
- **Governance**: AWS Control Tower for multi-account governance

### **Developer Experience**
- **Local Development**: Docker Compose for local development
- **Testing Framework**: Comprehensive testing suite with Jest/Mocha
- **Documentation**: Auto-generated API documentation
- **Code Quality**: SonarQube or similar code quality tools
- **Developer Portal**: Internal developer portal for service discovery

### **Monitoring & Alerting**
- **PagerDuty Integration**: On-call rotation and escalation
- **Slack/Teams**: Rich notification formatting
- **Custom Dashboards**: Grafana dashboards for business metrics
- **Anomaly Detection**: AWS Lookout for Metrics
- **Incident Management**: Integration with incident management tools

### **Data & Analytics**
- **Data Lake**: S3-based data lake for analytics
- **Real-time Analytics**: Kinesis Analytics for streaming data
- **Business Intelligence**: QuickSight for business dashboards
- **Data Pipeline**: Glue for ETL processes
- **Machine Learning**: SageMaker for predictive analytics

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review AWS CloudWatch logs
3. Check GitHub Actions logs
4. Open an issue in this repository

---

**Happy Deploying! 🚀**