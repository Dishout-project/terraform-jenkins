variable "vpc_name" {
    type    = string
    default = "jenkins-vpc"
}

variable "instance_name" {
    type    = string
    default = "jenkins-instance"
}

variable "machine_type" {
    type    = string
    default = "n1-standard-1"
}

variable "image" {
    type    = string
    default = "ubuntu-1804-bionic-v20200807"
}

variable "script" {
    type    = string
    default = "../packer/jenkins-setup/install.sh"
}

variable "tag" {
    type    = string
    default = "jenkins"
}

variable "static_ip_name" {
    type    = string
    default = "jenkins-static-ip"
}

variable "firewall_name" {
    type    = string
    default = "jenkins-firewall"
}