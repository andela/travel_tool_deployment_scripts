variable "project" {}

locals {
  region = "${terraform.workspace == "staging" ? "us-central1" : "europe-west1"}"
  zone = "${terraform.workspace == "staging" ? "us-central1-a": "europe-west1-b"}"
}

terraform {
  backend "gcs" {
    bucket  = "travela-tf-state"
    prefix  = "terraform/state"
  }
}

module "gke" {
  source = "./gke"
  project = "${var.project}"
  environment = "${terraform.workspace}"
  region = "${local.region}"
  zone = "${local.zone}"
}
