#Create VPC for AWS using terraform registry module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_igw = true

  name = "${local.main_prefix}-vpc"
  cidr = "10.16.0.0/16"

  azs              = ["eu-central-1a", "eu-central-1b"]
  public_subnets   = ["10.16.101.0/24", "10.16.102.0/24"]
  database_subnets = ["10.16.21.0/24", "10.16.22.0/24"]

  tags = var.tags
}

#Create Security Groups with rules to allow acces in resources

#EC2 SG with rules
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2-prod-sg"
  description = "Security group for EC2 Instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "212.146.66.99/32"
      description = "VPN"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "82.78.148.106/32"
      description = "Dragos IP"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "86.127.53.3/32"
      description = "Dragos IP2"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "34.141.49.99/32"
      description = "Gitlab Runner"
    },
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = "212.146.66.99/32"
      description = "Vpn flask acces"
    },

  ]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = "${module.alb_sg.security_group_id}"
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = "${module.alb_sg.security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 2

  egress_rules = [
    "all-all"
  ]

  tags = var.tags
}

#RDS SG with rules
module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "rds-prod-sg"
  description = "Security group for RDS Instances"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = "${module.ec2_sg.security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = [
    "all-all"
  ]

  tags = var.tags
}

#ALB Security Group with rules
module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "alb-prod-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_rules            = ["https-443-tcp", "http-80-tcp"]

  egress_rules = [
    "all-all"
  ]

  tags = var.tags
}
