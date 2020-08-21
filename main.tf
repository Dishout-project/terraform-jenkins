module "vpc" {
  source = "./modules/vpc"
  name = var.vpc_name
}

module "compute" {
  source       = "./modules/compute"
  network_name = var.vpc_name
  name         = var.instance_name
  machine_type = var.machine_type
  image        = var.image
  script       = var.script
  tag          = var.tag
}

resource "google_compute_network" "vpc_network" {
    name = "terraform-network"
  }
  
  resource "google_compute_instance" "jenkins_instance" {
    name         = "terraform-jenkins-instance"
    machine_type = "f1-micro"
    metadata_startup_script = file("scripts/install.sh")
  
    tags = ["dishout"]
  
  
    boot_disk {
      initialize_params {
        image = "ubuntu-1804-bionic-v20200807"
      }
    }
  
    network_interface {
      network = google_compute_network.vpc_network.name
      access_config {
        nat_ip = google_compute_address.static_ip.address
      }
    }
  }

  resource "google_compute_address" "static_ip" {
    name = "terraform-jenkins-static-ip"
  }
  
  resource "google_compute_firewall" "default" {
    name    = "test-jenkins-firewall"
    network = google_compute_network.vpc_network.name
  
    allow {
      protocol = "icmp"
    }
  
    allow {
      protocol = "tcp"
      ports    = ["22", "80", "443", "8080"]
    }
  
    source_tags = ["dishout"]
    source_ranges = ["0.0.0.0/0"]
  }