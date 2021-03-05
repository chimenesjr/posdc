output "host" {
 description = "Redis IP."
 value = google_redis_instance.redis_instance.host
}