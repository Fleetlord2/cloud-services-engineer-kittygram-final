variable "yc_token" {
  sensitive = true
}

variable "cloud_id" {}
variable "folder_id" {}

variable "zone" {
  default = "ru-central1-a"
}