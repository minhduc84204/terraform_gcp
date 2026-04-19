# Firewall rule to allow HTTP traffic
resource "google_compute_firewall" "default" {
  name    = "allow-http"
  network = google_compute_network.dao.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["http-server"]

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "allow-https"
  network = google_compute_network.dao.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags = ["http-servers"]

  source_ranges = ["0.0.0.0/0"]
}