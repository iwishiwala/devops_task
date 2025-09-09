# 🔒 HTTPS Setup Guide

This guide shows you how to enable HTTPS for your DevOps Takehome application using **FREE** methods.

## 🆓 Free Options

### Option 1: Free Domain + AWS Certificate Manager (Recommended)

#### Step 1: Get a Free Domain
1. **Freenom** (Easiest - Completely Free)
   - Go to [freenom.com](https://freenom.com)
   - Search for available domains (`.tk`, `.ml`, `.ga`, `.cf`)
   - Register your domain (e.g., `yourname.tk`)

2. **Alternative: Namecheap**
   - Often has $0.99 promotions
   - More reliable than Freenom

#### Step 2: Enable HTTPS Module
1. **Uncomment the HTTPS module** in `terraform/main.tf`:
   ```hcl
   module "https" {
     source = "./modules/https"
     
     domain_name        = "yourname.tk"  # Replace with your domain
     alb_arn           = module.ecs.alb_arn
     alb_listener_arn  = module.ecs.alb_listener_arn
     target_group_arn  = module.ecs.target_group_arn
     
     tags = {
       Environment = "takehome"
       Project     = "devops-takehome"
     }
   }
   ```

2. **Add domain variable** to `terraform/variables.tf`:
   ```hcl
   variable "domain_name" {
     description = "Domain name for HTTPS certificate"
     type        = string
     default     = ""
   }
   ```

3. **Update main.tf** to use the variable:
   ```hcl
   domain_name = var.domain_name
   ```

#### Step 3: Deploy Infrastructure
```bash
cd terraform
terraform plan
terraform apply
```

#### Step 4: Configure DNS
1. **Get your ALB DNS name**:
   ```bash
   terraform output alb_dns_name
   ```

2. **Create DNS records** in your domain provider:
   - **A Record**: `@` → ALB DNS name
   - **CNAME Record**: `www` → ALB DNS name

3. **Wait for certificate validation** (5-10 minutes)

### Option 2: Cloudflare Free SSL (Alternative)

#### Step 1: Get Domain + Setup Cloudflare
1. Get a free domain (any provider)
2. Sign up for [Cloudflare](https://cloudflare.com) (free plan)
3. Add your domain to Cloudflare
4. Change nameservers at your domain provider

#### Step 2: Configure Cloudflare
1. **SSL/TLS Settings**: Set to "Full (strict)"
2. **Create CNAME record**: `@` → your ALB DNS name
3. **Enable "Always Use HTTPS"**

## 🚀 Quick Start (Freenom Method)

### 1. Get Free Domain
```bash
# Go to freenom.com and register a .tk domain
# Example: mydevopsapp.tk
```

### 2. Enable HTTPS
```bash
# Edit terraform/main.tf
# Uncomment the HTTPS module and set your domain
```

### 3. Deploy
```bash
cd terraform
terraform apply
```

### 4. Configure DNS
```bash
# Get ALB DNS name
terraform output alb_dns_name

# Create A record in Freenom:
# Name: @
# Type: A
# Value: [ALB_DNS_NAME]
```

## 🔍 Verification

After setup, test your HTTPS:
```bash
# Test HTTPS endpoint
curl -I https://yourdomain.tk

# Should return:
# HTTP/2 200
# Strict-Transport-Security: max-age=31536000
```

## 🛠️ Troubleshooting

### Certificate Validation Fails
- Check DNS records are propagated (use `dig` or `nslookup`)
- Wait 10-15 minutes for DNS propagation
- Verify domain ownership

### ALB Not Responding
- Check security groups allow HTTPS (443)
- Verify target group health
- Check ECS service status

### Domain Not Resolving
- Verify DNS records point to ALB
- Check nameservers are correct
- Wait for DNS propagation

## 💰 Cost Impact

- **AWS Certificate Manager**: FREE
- **Route53**: $0.50/month per hosted zone
- **ALB**: $0.0225/hour + $0.008 per LCU-hour
- **Total additional cost**: ~$1-2/month

## 🎯 Benefits

✅ **Professional HTTPS** with valid certificate  
✅ **Automatic HTTP → HTTPS redirect**  
✅ **Security headers** and best practices  
✅ **Free SSL certificate** from AWS  
✅ **Production-ready** setup  

## 📚 Next Steps

1. **Get your free domain**
2. **Update the Terraform configuration**
3. **Deploy and test**
4. **Update your application URL** in documentation

Your application will then be accessible at `https://yourdomain.tk` with a valid SSL certificate! 🎉
