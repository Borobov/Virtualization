terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = "y0_AgAAAAA_XnM_AATuwQ-----------------------"
  cloud_id = "b1guuo9lt-----------"
  folder_id = "b1gjkmel-----------"
  zone = var.zone
}

resource "yandex_compute_instance" "vm-1" {

  name = "linux-vm"
  platform_id = "standard-v3"
  zone = var.zone

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8a67rb91j689dqp60h"
      size = 5
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("/root/cloud-terraform/meta.yaml")}"
  }
}

  resource "yandex_vpc_network" "network-1" {
    name = "network1"
  }

  resource "yandex_vpc_subnet" "subnet-1" {
    name = "subnet1"
    zone = "ru-central1-b"
    v4_cidr_blocks = ["192.168.10.0/24"]
    network_id = "${yandex_vpc_network.network-1.id}"
  }
