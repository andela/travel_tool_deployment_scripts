provider "google" {
  version     = "~> 2.8.0"
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.credentials}"
}
