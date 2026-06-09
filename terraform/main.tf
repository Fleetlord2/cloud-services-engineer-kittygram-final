resource "yandex_vpc_network" "network" {
  name = "kittygram-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "kittygram-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_security_group" "kittygram_sg" {
  name       = "kittygram-security-group"
  network_id = yandex_vpc_network.network.id

  # SSH
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing traffic
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "vm" {
  name = "kittygram-vm"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8f5k*************" # Ubuntu 22.04 (нужно взять актуальный ID!)
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kittygram_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}