resource "google_compute_network" "travela-network" {
  name = "travela-tf-${var.environment}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "travela-subnet" {
  name   = "travela-tf-${var.environment}-subnet"
  ip_cidr_range = "10.0.0.0/18"
  region = "${var.region}"
  network = "${google_compute_network.travela-network.self_link}"
  private_ip_google_access = "true"
}
