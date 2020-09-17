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
    default = "jenkins-pack-1600287623"
}

variable "image_family" {
    type    = string
    default = "jenkins"
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