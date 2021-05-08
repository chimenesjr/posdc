output "ip" {
    description = "Spark IP."
    value = google_compute_instance.spark.network_interface.0.access_config.0.nat_ip
}