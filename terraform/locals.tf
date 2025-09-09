locals {
  # Derive subnet CIDRs from VPC CIDR and number of AZs
  # Using cidrsubnet to create evenly split subnets per AZ
  # Adjust newbits/netnum scheme if you need larger/smaller subnets
  public_subnets  = [for i in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = [for i in range(length(var.azs)) : cidrsubnet(var.vpc_cidr, 8, i + 64)]

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  tags = {
    Environment = var.environment_name
    Project     = "devops-takehome"
  }
}


