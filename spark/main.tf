provider "google" {
    project     = var.project
    region      = var.region
}
 
resource "random_id" "instance_id" {
    byte_length = 8
}
 
resource "google_compute_instance" "spark" {
    name         = "spark"
    machine_type = "e2-medium" # e2-micro # e2-small
    zone         = var.zone
 
    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-2004-lts"
        }
    }
    
    metadata_startup_script =  file("startup.sh")

    network_interface {
        network = "default"
        
            access_config {
                
        }
    }
    
    tags = ["spark-firewall"]

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-full"]
    }
}
 
resource "google_compute_firewall" "default" {
    name    = "spark-firewall"
    network = "default"
    
    allow {
        protocol = "tcp"
        ports    = ["80","443", "8088", "50070", "50075", "9000", "8080" ]
    }
    
    allow {
        protocol = "icmp"
    }
}

# gcloud compute ssh spark --zone us-central1-a

# gcloud compute instances get-serial-port-output spark --port 1 --start 0 --zone us-central1-a