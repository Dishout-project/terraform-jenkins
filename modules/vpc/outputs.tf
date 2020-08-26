output "vpc_name" {
    value = google_compute_network.default.name
}

output "project_id" {
    value = google_compute_network.default.project
}