terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
  }

  backend "gcs" {
    bucket = "tfstate-nube-practica-1-507220"
    prefix = "practica-2"
  }
}

provider "google" {
  project = var.proyecto
  region  = "us-central1"
  zone    = var.zona
}

resource "google_compute_firewall" "permitir_http" {
  name    = "permitir-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["servidor-web"]
}

resource "google_compute_instance" "web" {
  name         = "web-tf"
  machine_type = var.tipo_maquina
  tags         = ["servidor-web"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

    allow_stopping_for_update = true

  metadata_startup_script = file("arranque.sh")
}


EVIDENCIA DEL APPLY: 
angelysofiapg@cloudshell:~/PRACTICA2 (nube-practica-1-507220)$  terraform apply -var tipo_maquina=e2-small
google_compute_firewall.permitir_http: Refreshing state... [id=projects/nube-practica-1-507220/global/firewalls/permitir-http]
google_compute_instance.web: Refreshing state... [id=projects/nube-practica-1-507220/zones/us-central1-a/instances/web-tf]

Changes to Outputs:
  ~ ip_externa = "34.71.41.101" -> "34.71.75.158"

You can apply this plan to save these new output values to the Terraform state, without changing any real infrastructure.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

ip_externa = "34.71.75.158"

EVIDENCIA IP:

angelysofiapg@cloudshell:~/PRACTICA2 (nube-practica-1-507220)$  terraform output ip_externa
"34.71.75.158"

EVIDENCIA 5: 

Destroy complete! Resources: 2 destroyed.

real    0m25.827s
user    0m5.658s
sys     0m0.854s

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

ip_externa = "34.71.75.158"

real    0m41.088s
user    0m4.818s
sys     0m0.606s
angelysofiapg@cloudshell:~/PRACTICA2 (nube-practica-1-507220)$ 
