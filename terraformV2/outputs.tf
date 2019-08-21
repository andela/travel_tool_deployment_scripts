output "ip-address" {
  value = "${module.gke.ip-address}"
  sensitive   = true
}

output "cluster-name" {
  value = "${module.gke.cluster-name}"
}

output "cluster-zone" {
  value = "${module.gke.cluster-zone}"
}

output "gcp-project-id" {
  value = "${module.gke.gcp-project-id}"
}

output "database-user-name" {
  value = "${module.gke.database-user-name}"
}

output "database-user-password" {
  value = "${module.gke.database-user-password}"
  sensitive   = true
}
