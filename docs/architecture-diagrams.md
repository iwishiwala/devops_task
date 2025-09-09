# Architecture Diagrams

This document contains Mermaid diagrams that can be rendered in GitHub, GitLab, or other Markdown viewers that support Mermaid.

## System Architecture Overview

```mermaid
graph TB
    subgraph "GitHub Repository"
        GH[GitHub Actions CI/CD]
        CODE[Application Code]
        TF[Terraform Infrastructure]
    end
    
    subgraph "AWS Cloud"
        subgraph "VPC (10.0.0.0/16)"
            subgraph "Public Subnets"
                ALB[Application Load Balancer]
                NAT[NAT Gateway]
            end
            
            subgraph "Private Subnets"
                ECS[ECS Fargate Cluster]
                TASK[Container Tasks]
            end
        end
        
        subgraph "Container Services"
            ECR[Elastic Container Registry]
            ECS_SERVICE[ECS Service]
        end
        
        subgraph "Monitoring & Logging"
            CW[CloudWatch]
            SNS[SNS Topic]
            DASH[CloudWatch Dashboard]
        end
        
        subgraph "Security & Secrets"
            IAM[IAM Roles & Policies]
            SECRETS[Secrets Manager]
            OIDC[GitHub OIDC Provider]
        end
        
        subgraph "Optional HTTPS"
            ACM[Certificate Manager]
            R53[Route 53]
        end
    end
    
    subgraph "External"
        USER[End Users]
        DEV[Developers]
        SLACK[Slack/Email Alerts]
    end
    
    %% Connections
    GH -->|OIDC Auth| IAM
    GH -->|Build & Push| ECR
    GH -->|Deploy| ECS_SERVICE
    
    USER -->|HTTPS/HTTP| ALB
    ALB -->|Load Balance| ECS_SERVICE
    ECS_SERVICE -->|Run| TASK
    
    TASK -->|Logs| CW
    TASK -->|Metrics| CW
    CW -->|Alerts| SNS
    SNS -->|Notifications| SLACK
    
    TASK -->|Retrieve| SECRETS
    
    CODE -->|Docker Build| ECR
    TF -->|Provision| ALB
    TF -->|Provision| ECS
    TF -->|Provision| CW
    TF -->|Provision| SECRETS
    
    DEV -->|Code Push| GH
    DEV -->|Monitor| DASH
```

## Infrastructure Components

```mermaid
graph LR
    subgraph "Terraform Modules"
        VPC_MOD[VPC Module]
        ECS_MOD[ECS Module]
        ECR_MOD[ECR Module]
        MON_MOD[Monitoring Module]
        SEC_MOD[Secrets Module]
        HTTPS_MOD[HTTPS Module]
        OIDC_MOD[GitHub OIDC Module]
    end
    
    subgraph "AWS Resources"
        VPC[VPC & Subnets]
        ALB[Load Balancer]
        ECS[ECS Cluster & Service]
        ECR[Container Registry]
        CW[CloudWatch]
        SNS[SNS Topic]
        SECRETS[Secrets Manager]
        IAM[IAM Roles]
    end
    
    VPC_MOD --> VPC
    ECS_MOD --> ALB
    ECS_MOD --> ECS
    ECR_MOD --> ECR
    MON_MOD --> CW
    MON_MOD --> SNS
    SEC_MOD --> SECRETS
    OIDC_MOD --> IAM
    HTTPS_MOD --> ALB
```

## CI/CD Pipeline Flow

```mermaid
graph TD
    A[Code Push to GitHub] --> B[GitHub Actions Trigger]
    B --> C[OIDC Authentication]
    C --> D[Build Docker Image]
    D --> E[Push to ECR]
    E --> F[Generate Task Definition]
    F --> G[Deploy to ECS]
    G --> H[Wait for Service Stability]
    H --> I[Health Check - Basic Connectivity]
    I --> J[Health Check - Application Endpoints]
    J --> K[Health Check - Infrastructure Status]
    K --> L[Performance Test]
    L --> M[Update PR Comment]
    M --> N[Deployment Complete]
    
    I -->|Fail| O[Rollback]
    J -->|Fail| O
    K -->|Fail| O
    L -->|Fail| O
    O --> P[Notify Failure]
```

## Network Architecture

```mermaid
graph TB
    subgraph "Internet"
        USER[End Users]
    end
    
    subgraph "AWS VPC (10.0.0.0/16)"
        subgraph "Public Subnet A (10.0.1.0/24)"
            ALB_A[Application Load Balancer]
            NAT_A[NAT Gateway A]
        end
        
        subgraph "Public Subnet B (10.0.2.0/24)"
            NAT_B[NAT Gateway B]
        end
        
        subgraph "Private Subnet A (10.0.10.0/24)"
            ECS_A[ECS Tasks A]
        end
        
        subgraph "Private Subnet B (10.0.20.0/24)"
            ECS_B[ECS Tasks B]
        end
    end
    
    subgraph "AWS Services"
        ECR[ECR Registry]
        CW[CloudWatch]
        SECRETS[Secrets Manager]
    end
    
    USER -->|HTTPS/HTTP| ALB_A
    ALB_A -->|Load Balance| ECS_A
    ALB_A -->|Load Balance| ECS_B
    
    ECS_A -->|Pull Images| ECR
    ECS_B -->|Pull Images| ECR
    
    ECS_A -->|Logs & Metrics| CW
    ECS_B -->|Logs & Metrics| CW
    
    ECS_A -->|Retrieve Secrets| SECRETS
    ECS_B -->|Retrieve Secrets| SECRETS
    
    ECS_A -->|Outbound| NAT_A
    ECS_B -->|Outbound| NAT_B
```

## Security Architecture

```mermaid
graph TB
    subgraph "External"
        DEV[Developers]
        USER[End Users]
    end
    
    subgraph "GitHub"
        REPO[Repository]
        ACTIONS[GitHub Actions]
    end
    
    subgraph "AWS Security"
        subgraph "Identity & Access"
            OIDC[OIDC Provider]
            IAM_ROLE[IAM Role]
            IAM_POLICY[IAM Policies]
        end
        
        subgraph "Network Security"
            VPC[VPC]
            SG[Security Groups]
            NACL[Network ACLs]
        end
        
        subgraph "Data Security"
            KMS[KMS Encryption]
            SECRETS[Secrets Manager]
            EBS[EBS Encryption]
        end
        
        subgraph "Monitoring"
            CLOUDTRAIL[CloudTrail]
            CONFIG[AWS Config]
            CW[CloudWatch]
        end
    end
    
    DEV -->|Push Code| REPO
    REPO -->|Trigger| ACTIONS
    ACTIONS -->|OIDC Token| OIDC
    OIDC -->|Assume Role| IAM_ROLE
    IAM_ROLE -->|Execute| IAM_POLICY
    
    USER -->|HTTPS| VPC
    VPC -->|Filter| SG
    VPC -->|Control| NACL
    
    IAM_ROLE -->|Encrypt| KMS
    KMS -->|Protect| SECRETS
    KMS -->|Protect| EBS
    
    ACTIONS -->|Audit| CLOUDTRAIL
    VPC -->|Compliance| CONFIG
    ECS -->|Monitor| CW
```

## Monitoring & Alerting Architecture

```mermaid
graph TB
    subgraph "Application Layer"
        APP[Node.js Application]
        HEALTH[Health Endpoints]
    end
    
    subgraph "Infrastructure Layer"
        ECS[ECS Fargate]
        ALB[Application Load Balancer]
        ECR[ECR Registry]
    end
    
    subgraph "AWS Monitoring"
        subgraph "CloudWatch"
            METRICS[Custom Metrics]
            LOGS[Log Groups]
            DASHBOARD[Dashboard]
        end
        
        subgraph "Alerting"
            ALARMS[CloudWatch Alarms]
            SNS[SNS Topic]
            EMAIL[Email Notifications]
            SLACK[Slack Notifications]
        end
    end
    
    subgraph "External Monitoring"
        GITHUB[GitHub Actions]
        PR[Pull Request Comments]
    end
    
    APP -->|Metrics| METRICS
    APP -->|Logs| LOGS
    HEALTH -->|Health Status| METRICS
    
    ECS -->|CPU/Memory| METRICS
    ALB -->|Request Count| METRICS
    ALB -->|Response Time| METRICS
    ECR -->|Image Pulls| METRICS
    
    METRICS -->|Thresholds| ALARMS
    LOGS -->|Error Patterns| ALARMS
    
    ALARMS -->|Trigger| SNS
    SNS -->|Send| EMAIL
    SNS -->|Send| SLACK
    
    GITHUB -->|Deploy| ECS
    GITHUB -->|Health Check| APP
    GITHUB -->|Update| PR
```

## Cost Optimization Architecture

```mermaid
graph TB
    subgraph "Cost Optimization Strategies"
        subgraph "Compute"
            FARGATE[ECS Fargate]
            SPOT[Fargate Spot]
            SCALE[Auto Scaling]
        end
        
        subgraph "Storage"
            ECR[ECR Registry]
            LIFECYCLE[Lifecycle Policies]
            CLEANUP[Automatic Cleanup]
        end
        
        subgraph "Monitoring"
            BUDGET[Budget Alerts]
            COST[Cost Explorer]
            OPTIMIZE[Cost Optimization]
        end
        
        subgraph "Free Tier"
            VPC[VPC - Always Free]
            CW[CloudWatch - 10 Metrics]
            SNS[SNS - 1M Requests]
            ECR_FREE[ECR - 500MB]
        end
    end
    
    subgraph "AWS Services"
        ECS[ECS Service]
        ECR_REG[ECR Registry]
        CW_SVC[CloudWatch]
        SNS_SVC[SNS]
    end
    
    FARGATE -->|Pay per use| ECS
    SPOT -->|70% savings| ECS
    SCALE -->|Scale to zero| ECS
    
    ECR -->|Store images| ECR_REG
    LIFECYCLE -->|Delete old| CLEANUP
    CLEANUP -->|Reduce storage| ECR_REG
    
    BUDGET -->|Alert on spend| COST
    COST -->|Analyze costs| OPTIMIZE
    OPTIMIZE -->|Recommend| FARGATE
    
    VPC -->|Free| ECS
    CW -->|Free tier| CW_SVC
    SNS -->|Free tier| SNS_SVC
    ECR_FREE -->|Free tier| ECR_REG
```

### Optimized Pipeline Flow

```mermaid
graph TD
    A[Code Push to GitHub] --> B{File Type Check}
    B -->|Application Files| C[Deploy to ECS Workflow]
    B -->|Infrastructure Files| D[Infrastructure Workflow]
    B -->|Documentation Only| E[Skip Deployment]
    
    C --> F[OIDC Authentication]
    F --> G[Build Docker Image]
    G --> H[Push to ECR]
    H --> I[Generate Task Definition]
    I --> J[Deploy to ECS]
    J --> K[Wait for Service Stability]
    K --> L[Health Check - Basic Connectivity]
    L --> M[Health Check - Application Endpoints]
    M --> N[Health Check - Infrastructure Status]
    N --> O[Performance Test]
    O --> P[Update PR Comment]
    P --> Q[Deployment Complete]
    
    D --> R[Terraform Plan/Apply]
    R --> S[Infrastructure Validation]
    S --> T[Update Infrastructure]
    
    L -->|Fail| U[Rollback]
    M -->|Fail| U
    N -->|Fail| U
    O -->|Fail| U
    U --> V[Notify Failure]
```

### Pipeline Triggers

```mermaid
graph LR
    subgraph "File Changes"
        APP[Application Files]
        INFRA[Infrastructure Files]
        DOCS[Documentation Files]
    end
    
    subgraph "Pipeline Triggers"
        DEPLOY[Deploy to ECS]
        INFRA_WF[Infrastructure Workflow]
        SKIP[Skip Deployment]
    end
    
    subgraph "Application Files"
        INDEX[index.js]
        PKG[package.json]
        DOCKER[Dockerfile]
        APP_DIR[app/**]
    end
    
    subgraph "Infrastructure Files"
        TF[terraform/**]
        WF[workflow files]
    end
    
    subgraph "Documentation Files"
        README[README.md]
        DOCS_DIR[docs/**]
        SCRIPTS[scripts/**]
    end
    
    APP --> DEPLOY
    INFRA --> INFRA_WF
    DOCS --> SKIP
    
    INDEX --> APP
    PKG --> APP
    DOCKER --> APP
    APP_DIR --> APP
    
    TF --> INFRA
    WF --> INFRA
    
    README --> DOCS
    DOCS_DIR --> DOCS
    SCRIPTS --> DOCS
```

## How to Generate Visual Diagrams

### Option 1: GitHub/GitLab (Automatic)
- The diagrams above will render automatically in GitHub and GitLab
- Just view this file in the repository

### Option 2: Mermaid Live Editor
1. Go to [Mermaid Live Editor](https://mermaid.live/)
2. Copy any diagram code from above
3. Paste into the editor
4. Export as PNG, SVG, or PDF

### Option 3: VS Code Extension
1. Install "Mermaid Preview" extension
2. Open this file in VS Code
3. Use Command Palette: "Mermaid Preview"

### Option 4: Command Line
```bash
# Install Mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Generate PNG
mmdc -i architecture-diagrams.md -o architecture-diagrams.png

# Generate SVG
mmdc -i architecture-diagrams.md -o architecture-diagrams.svg
```

### Option 5: Online Tools
- [Mermaid Chart](https://www.mermaidchart.com/)
- [Draw.io](https://app.diagrams.net/) (import Mermaid)
- [Lucidchart](https://www.lucidchart.com/) (import Mermaid)
