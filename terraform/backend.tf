terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "fleetlord-backet"
    region     = "ru-central1"
    key        = "terraform.tfstate"

    access_key = var.access_key
    secret_key = var.secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}