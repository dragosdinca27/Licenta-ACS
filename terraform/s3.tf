#S3 bucket to keep data
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "licenta-prod-bucket"
  acl    = "private"

  versioning = {
    enabled = false
  }

  tags = var.tags

}
