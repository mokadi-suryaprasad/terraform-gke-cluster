# resource "google_compute_firewall" "allow_iap_ssh" {
#   name    = "allow-iap-ssh"
#   network = google_compute_network.vpc.name

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["35.235.240.0/20"]
# }

resource "google_compute_firewall" "allow_custom_ports" {
  name    = "allow-custom-ports"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "9090", "9093"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow from all IPs (Adjust for security)
}
