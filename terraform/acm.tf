data "aws_acm_certificate" "acm" {
  domain   = "deprinsud.com"
  statuses = ["ISSUED"]
}
