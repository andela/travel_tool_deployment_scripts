output "ip-address" {
  value = "${google_compute_address.travela-static-address.address}"
  sensitive   = true
}

output "cluster-name" {
  value = "${google_container_cluster.travela-cluster.name}"
}

output "cluster-zone" {
  value = "${google_container_cluster.travela-cluster.zone}"
}

output "gcp-project-id" {
  value = "${google_container_cluster.travela-cluster.project}"
}

output "database-user-name" {
  value = "${google_sql_user.travela-database-user.name}"
}

output "database-user-password" {
  value = "${google_sql_user.travela-database-user.password}"
  sensitive   = true
}
