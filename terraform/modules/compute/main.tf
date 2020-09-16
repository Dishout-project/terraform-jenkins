resource "google_compute_instance" "instance" {
    name = var.instance_name
    machine_type = var.machine_type

    tags = [var.tag]

    boot_disk {
        initialize_params {
            image = var.image
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
