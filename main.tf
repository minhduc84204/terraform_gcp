
provider "google" {
  project = var.project_id
  region  = "asia-southeast1"
  zone    = "asia-southeast1-b"
}
resource "google_compute_network" "dao"{
    name = "dao-network"
    auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "dao_subnetwork" {
    name = "dao-subnet"
    ip_cidr_range = "10.0.1.0/24"
    region = "asia-southeast1"
    network = google_compute_network.dao.self_link
}

resource "google_compute_instance" "vm_instance" {
  #count = length(var.instance_names)

  #name         = var.instance_names[count.index]
  name         = var.instance_names
  machine_type = var.environment == "production" ? var.machine_type : var.machine_type_dev
  description = "This is Dao virtual machine1"

  boot_disk {
    initialize_params {
      image = var.image
      size = 20
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.dao_subnetwork.id

    access_config {
      # This gives external IP
    }
  }

  # Allow HTTP traffic
  tags = ["http-server","http-servers","ssh"]

metadata_startup_script = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>Hello from Terraform TMA Solutions </h1>" > /var/www/html/index.html
EOF
}

resource "google_compute_disk" "default" {
    name = "dao-disk1"
    type = "pd-ssd"
    zone = "asia-southeast1-b"
    size = 10
}

resource "google_compute_attached_disk" "default" {
    disk = google_compute_disk.default.self_link
    instance = google_compute_instance.vm_instance.self_link
}

# # Firewall rule to allow HTTP traffic
# resource "google_compute_firewall" "default" {
#   name    = "allow-http"
#   network = "default"

#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }

#   target_tags = ["http-server"]

#   source_ranges = ["0.0.0.0/0"]
# }

# Output external IP
#output "vm_external_ip" {
#  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
#}
