module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
}

module "compute" {
  source         = "./modules/compute"
  vpc_name       = module.vpc.vpc_name
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  tag            = var.tag
  image          = var.jenkins_image_ID
  script         = var.script
  static_ip_name = var.static_ip_name
}

module "network" {
  source         = "./modules/network"
  firewall_name  = var.firewall_name
  vpc_name       = module.vpc.vpc_name
}
  
