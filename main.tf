# Main Terraform configuration file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "sg" {
  source = "./modules/sg"

  vpc_id = module.vpc.vpc_id

}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  security_groups = [module.sg.alb_security_group_id]
  public_subnets  = module.vpc.public_subnet_ids
  name            = var.name

  target_groups = {
    homepage = {
      name = "default"
      path = "/"
      port = 80
      priority = 100
    }
    images = {
      name     = "images"
      path     = "/images*"
      port     = 80
      priority = 101
    }
    register = {
      name     = "register"
      path     = "/register*"
      port     = 80
      priority = 102
    }
  }
}


module "ec2" {
  source = "./modules/ec2"

  vpc_id                  = module.vpc.vpc_id
  public_subnets          = module.vpc.public_subnet_ids
  instance_security_group = module.sg.instance_security_group_id

  target_group_arns = {
    default  = module.alb.target_group_arns["homepage"]
    images   = module.alb.target_group_arns["images"]
    register = module.alb.target_group_arns["register"]
  }

  instances = {
    default = {
      name         = "default-instance"
      subnet_index = 0
      user_data    = <<-EOF
                     #!/bin/bash
                     apt-get update
                     apt-get install -y nginx
                     systemctl start nginx
                     systemctl enable nginx
                     cat > /var/www/html/index.html << 'EOT'
                     <!DOCTYPE html>
                     <html>
                     <head>
                         <title>default</title>
                     </head>
                     <body>
                         <h1>default!</h1>
                         <p>Instance A</p>
                         <ul>
                             <li><a href="/images">Go to Images</a></li>
                             <li><a href="/register">Go to Register</a></li>
                         </ul>
                     </body>
                     </html>
                     EOT
                     EOF
    }
    images = {
      name         = "images-instance"
      subnet_index = 1
      user_data    = <<-EOF
                     #!/bin/bash
                     apt-get update
                     apt-get install -y nginx
                     systemctl start nginx
                     systemctl enable nginx
                     mkdir -p /var/www/html/images
                     cat > /var/www/html/images/index.html << 'EOT'
                     <!DOCTYPE html>
                     <html>
                     <head>
                         <title>Images</title>
                     </head>
                     <body>
                         <h1>Images!</h1>
                         <p>Instance B </p>
                         <a href="/">Back to Homepage</a>
                     </body>
                     </html>
                     EOT
                     EOF
    }
    register = {
      name         = "register-instance"
      subnet_index = 2
      user_data    = <<-EOF
                     #!/bin/bash
                     apt-get update
                     apt-get install -y nginx
                     systemctl start nginx
                     systemctl enable nginx
                     mkdir -p /var/www/html/register
                     cat > /var/www/html/register/index.html << 'EOT'
                     <!DOCTYPE html>
                     <html>
                     <head>
                         <title>Register</title>
                     </head>
                     <body>
                         <h1>Register!</h1>
                         <p>Instance C - Register Path (/register)</p>
                         <a href="/">Back to Homepage</a>
                     </body>
                     </html>
                     EOT
                     EOF
    }
  }
}