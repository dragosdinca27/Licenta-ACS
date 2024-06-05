#ASG from AWS Terraform registry module
#https://github.com/terraform-aws-modules/terraform-aws-autoscaling

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${local.main_prefix}-ec2"

  # Launch configuration
  lc_name = "prod-web-lc"

  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  security_groups = [module.ec2_sg.security_group_id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.arn

  key_name                    = aws_key_pair.aws_key.id
  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size = "20"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${local.main_prefix}-asg"
  vpc_zone_identifier       = module.vpc.public_subnets
  health_check_type         = "EC2"
  min_size                  = 3
  max_size                  = 10
  desired_capacity          = 3
  wait_for_capacity_timeout = 0
  target_group_arns         = module.alb.target_group_arns

  tags = [
    {
      key                 = "Environment"
      value               = "prod"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${local.main_prefix}-ec2"
      propagate_at_launch = true
    },
    {
      key                 = "created_by"
      value               = "terraform"
      propagate_at_launch = true
    },
  ]
}


#ALB from Terraform AWS registry module
# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "${local.main_prefix}"

  load_balancer_type = "application"

  enable_deletion_protection = true

  vpc_id          = "${module.vpc.vpc_id}"
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm.arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
      target_group_index = 0
    }
  ]

  tags = var.tags
}
