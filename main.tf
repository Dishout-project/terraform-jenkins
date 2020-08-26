module "vpc" {
  source = "./modules/vpc"
  name = var.vpc_name
}

module "compute" {
  source         = "./modules/compute"
  vpc            = var.vpc_name
  instance       = var.instance_name
  machine_type   = var.machine_type
  image          = var.image
  script         = var.script
  tag            = var.tag
  static_ip_name = var.static_ip_name
}

module "network" {
  firewall       = var.firewall_name
  vpc            = var.vpc_name
  tag            = var.tag  

}
  