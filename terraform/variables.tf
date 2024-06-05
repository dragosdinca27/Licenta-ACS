variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    environment = "prod"
    created_by  = "terraform"
  }
}

variable "db_admin_username" {
  description = "The default username of the master DB user"
  default     = ""
}

variable "db_admin_password" {
  description = "The default password of the master DB user"
  default     = ""
}
