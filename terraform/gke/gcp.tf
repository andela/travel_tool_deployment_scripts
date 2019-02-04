provider "google" {
  version = "~> 1.20.0"
  project = "${var.project}"
  region = "${var.region}"
  zone = "${var.zone}"
}
