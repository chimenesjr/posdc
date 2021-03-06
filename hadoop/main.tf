provider "google" {
    project     = var.project
    region      = var.region
}
 
resource "random_id" "instance_id" {
    byte_length = 8
}
 
resource "google_compute_instance" "hadoop" {
    name         = "hadoop"
    machine_type = "f1-micro"
    zone         = var.zone
 
    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-1604-lts"
        }
    }
    
    metadata_startup_script =  file("startup.sh")

    network_interface {
        network = "default"
        
            access_config {
                
        }
    }
    
    tags = ["mongo-firewall"]

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}
 
resource "google_compute_firewall" "default" {
    name    = "mongo-firewall"
    network = "default"
    
    allow {
        protocol = "tcp"
        ports    = ["80","443", "27017"]
    }
    
    allow {
        protocol = "icmp"
    }
}

# gcloud compute ssh hadoop --zone us-central1-a

# gcloud compute instances get-serial-port-output hadoop --port 1 --start 0 --zone us-central1-a