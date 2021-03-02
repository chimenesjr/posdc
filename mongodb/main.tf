# gcloud compute ssh mongodb --zone us-central1-a

provider "google" {
    project     = var.project
    region      = var.region
}
 
resource "random_id" "instance_id" {
    byte_length = 8
}
 
resource "google_compute_instance" "mongodb" {
    name         = "mongodb"
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

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}
 
resource "google_compute_firewall" "default" {
    name    = "nginx-firewall"
    network = "default"
    
    allow {
        protocol = "tcp"
        ports    = ["80","443"]
    }
    
    allow {
        protocol = "icmp"
    }
}
