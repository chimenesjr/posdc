resource "google_redis_instance" "redis_instance" {
    name                = "redis"
    tier                = "BASIC"
    memory_size_gb      = 1
    region              = var.region
    redis_version       = "REDIS_5_0"
    project             = var.project
    authorized_network  = "default"
}