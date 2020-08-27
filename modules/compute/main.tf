resource "google_compute_instance" "instance" {
    name = var.instance_name
    machine_type = var.machine_type
    metadata_startup_script = file(var.script)

    tags = [var.tag]

    boot_disk {
        initialize_params {
            image = var.image
        }
    }

    network_interface {
        network = var.vpc_name
    }
}

resource "google_compute_address" "static_ip" {
    name = var.static_ip_name
}