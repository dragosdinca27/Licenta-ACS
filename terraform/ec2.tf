#Use data for ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#ADD ssh public key
resource "aws_key_pair" "aws_key" {
  key_name   = "prj_aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCa6HqCYtzXxCJeWPp8+HXL5N27f189eMEFqzfceE7uIs2KeLafsIO400CMiiKxbk7UI0WjmztXQHAR5Tkwr6Fwp+i5y2yuBZlr0DUGgQLVcDVDIra7oby2+oiIaAeR7cf2CD1MuiAoTHwe+9mvw8bV2gCZSzQp4VkZmnHGx8RJmUthfu0UtK/I/aXKvTF/7B76iFj7SWEcLHYBzbVkU1uVB5WbGVMocN4Yc7yWb4JJWqLEQflY8wx1Wimyqh0ki/QlWTonQjns8UMRqObg4UDVwnwIChgj1D2XOM9Se3ZvM1LjI8t1FAJs5wrRVIwgXEJmiUqJg/AOlT0w4G0Cl1dginXx1SPPQ7KE585Shw02zgG1mIzkC9l+WdMM3Tyd4rdHae3uD3LS1anXo6pd9KPHbi9k9FkW1Es6S519YHtyeXgB2JRBhghv/aTJBlMo2Q4P15TV/0bD80qXgvq5fFwLCTkl8v/aOTqx0oGpmgEgYC71u4hDkxfHy9R8KEWpaHJf+OM8inOTKnuU3IKKcIxWVz7JHoysR+m9GBqJ+Qb+axUoqp0taMKKsTUZ3Wmdv1mYrrGE6GOGMIPtWs7SKTMy0xW3jJ69Xo7f61qK1uXNRYD2zmjEbVOTOdTKfGic59LzJvagQEDZbIhK+EzOYU7xVPeVT3cks24KHW4NMBVf1w== ddinca@DDINCA"
}

#EC2 Instance for test
resource "aws_instance" "ec2_stg" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  key_name               = aws_key_pair.aws_key.id
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    environment = "prod"
    created_by  = "terraform"
    Name        = "web-ec2"
  }
}




