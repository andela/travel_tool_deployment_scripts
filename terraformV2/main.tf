locals {
  region   = "${terraform.workspace == "staging" ? "us-central1" : "europe-west1"}"
  location = "${terraform.workspace == "staging" ? "us-central1-a" : "europe-west1-b"}"
}

terraform {
  backend "gcs" {}
}

data "terraform_remote_state" "travela" {
  backend = "gcs"

  config = {
    bucket      = "${var.bucket}"
    prefix      = "terraform/state"
    credentials = "${var.credentials}"
  }
}


module "gke" {
  source               = "./gke"
  project              = "${var.project}"
  environment          = "${terraform.workspace}"
  machine_type         = "${var.machine_type}"
  credentials          = "${var.credentials}"
  region               = "${local.region}"
  location             = "${local.location}"
  product              = "${var.product}"
  owner                = "${var.owner}"
  maintainer           = "${var.maintainer}"
  db_backup_start_time = "${var.db_backup_start_time}"
  db_instance_tier     = "${var.db_instance_tier}"
  db_user              = "${var.db_user}"
}
