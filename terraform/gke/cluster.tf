resource "google_container_cluster" "travela-cluster" {
  name               = "travela-tf-${var.environment}"
  zone               = "${var.zone}"
  network = "${google_compute_network.travela-network.self_link}"
  subnetwork = "${google_compute_subnetwork.travela-subnet.self_link}"
  resource_labels = {
    product = "${var.product}"
    component = "frontend_backend"
    env = "${var.environment}"
    owner = "${var.owner}"
    maintainer = "${var.maintainer}"
    state = "in_use"
  }
  node_pool = [{
    name = "default-pool"
    node_count = 2

    autoscaling {
      min_node_count = 2
      max_node_count = 5
    }

    management {
      auto_upgrade = true
    }
  }]
}
