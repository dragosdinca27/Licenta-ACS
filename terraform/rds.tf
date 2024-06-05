#RDS from Terraform Registiry Module
#https://github.com/terraform-aws-modules/terraform-aws-rds

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "${local.main_prefix}-rds"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t2.micro"
  allocated_storage = 10

  name     = "licentaprod"
  username = local.db_admin_username
  password = local.db_admin_password
  port     = "3306"

  # iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.rds_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automaticall
  # monitoring_interval    = "15"
  # monitoring_role_name   = "RDS-Licenta-Prod"
  create_monitoring_role = false

  performance_insights_enabled = false

  max_allocated_storage = 50

  tags = var.tags

  # DB subnet group
  subnet_ids = module.vpc.database_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  #  Snapshot name upon DB deletion
  final_snapshot_identifier = "prod-db"

  # Database Deletion Protection
  deletion_protection = true
}
