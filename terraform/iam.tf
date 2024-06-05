# IAM Role to be granted ECR permissions
module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 2.0"

  create_role = true

  trusted_role_arns = [
    "arn:aws:iam::215722272207:root"
  ]

  trusted_role_services = [
    "codedeploy.amazonaws.com",
    "ec2.amazonaws.com"
  ]

  role_name         = "ecrrole"
  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite",
  ]
}

# https://registry.terraform.io/modules/yukihira1992/iam-service-role/aws/latest
module "iam_service_role" {
  source = "yukihira1992/iam-service-role/aws"

  name = "service-role-for-codedeploy"
  service_ids = [
    "codedeploy.amazonaws.com",
    "ec2.amazonaws.com"
  ]
  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
  ]

  tags = var.tags
}

#IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2profile"
  role = module.iam_assumable_role.this_iam_role_name
}
