resource "google_compute_network" "default" {
    name = var.vpc_name
    project = var.project_id
}