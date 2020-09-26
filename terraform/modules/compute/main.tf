data "google_compute_image" "jenkins_image" {
  family  = var.image_family
#   labels = {
#     image-type = "release"
#     }
}

resource "google_compute_instance" "instance" {
    name = var.instance_name
    machine_type = var.machine_type

    tags = [var.tag]

    boot_disk {
        initialize_params {
            image = data.google_compute_image.jenkins_image.self_link
        }
    }

    network_interface {
        network = var.vpc_name
        access_config {
            nat_ip = google_compute_address.static_ip.address
            // Ephemeral IP
    }
}
}

resource "google_compute_address" "static_ip" {
    name = var.static_ip_name
}
