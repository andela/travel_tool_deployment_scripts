resource "google_sql_database_instance" "travela-db-instance" {
  region           = "${var.region}"
  database_version = "POSTGRES_9_6"
  name             = "${var.environment}-travela-db-instance"

  settings {
    tier              = "${var.db_instance_tier}"
    availability_type = "REGIONAL"
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled = true
    }

    backup_configuration {
      enabled    = true
      start_time = "${var.db_backup_start_time}"
    }
  }
}

resource "google_sql_user" "travela-database-user" {
  name     = "${var.db_user}"
  password = "${var.db_password}"
  instance = "${google_sql_database_instance.travela-db-instance.name}"
  host     = ""
}

resource "google_sql_database" "travela-database" {
  name      = "${var.environment}-travela-api-database"
  instance  = "${google_sql_database_instance.travela-db-instance.name}"
  charset   = "UTF8"
  collation = "en_US.UTF8"
}

resource "google_sql_database" "travela-machine-learning-database" {
  name      = "${var.environment}-travela-machine-learning-database"
  instance  = "${google_sql_database_instance.travela-db-instance.name}"
  charset   = "UTF8"
  collation = "en_US.UTF8"
}
