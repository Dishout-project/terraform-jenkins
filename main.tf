module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
}

module "compute" {
  source         = "./modules/compute"
  vpc_name       = var.vpc_name
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  image          = var.image
  script         = var.script
  tag            = var.tag
  static_ip_name = var.static_ip_name
}

module "network" {
  source         = "./modules/network"
  firewall_name  = var.firewall_name
  vpc_name       = var.vpc_name
  tag            = var.tag  

}
  