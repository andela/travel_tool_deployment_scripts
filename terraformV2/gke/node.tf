resource "google_container_node_pool" "travela-node-pool" {
  name       = "travela-tf-${var.environment}-node-pool"
  location   = "${var.location}"
  cluster    = "${google_container_cluster.travela-cluster.name}"
  node_count = 3

  // Configuration for each node to be created
  node_config {
    preemptible  = true
    machine_type = "${var.machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    // set of google API's made available on all of the nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 6
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
