output "ip" {
    description = "Hadoop IP."
    value = google_compute_instance.hadoop.network_interface.0.access_config.0.nat_ip
}