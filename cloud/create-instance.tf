resource "random_id" "run_name" {
  byte_length = 8
  prefix = "gcp"
}
resource "google_compute_subnetwork" "sub_network" {
  name = "${random_id.run_name.hex}-sub-network"

  ip_cidr_range = "10.0.0.0/22"
  region        = var.gcp_region

  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"

  network = google_compute_network.vpc_network.id
}

resource "google_compute_network" "vpc_network" {
  name                     = "${random_id.run_name.hex}-vpc-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_instance" "compute" {
  name         = "${random_id.run_name.hex}-${count.index}"
  machine_type = "n2d-standard-2"
  zone         = var.gcp_zone
  count        = 2

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  confidential_instance_config {
    enable_confidential_compute = true
  }
  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    stack_type = "IPV4_IPV6"
    subnetwork = google_compute_subnetwork.sub_network.id

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  # metadata_startup_script = ""
  metadata_startup_script = file("${path.module}/startup.sh")

  // Apply the firewall rule to allow external IPs to access this instance
  tags = ["${random_id.run_name.hex}"]
}

resource "google_compute_firewall" "http-server" {
  name    = "${random_id.run_name.hex}-firewall"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  target_tags   = ["${random_id.run_name.hex}"]
  source_ranges = ["0.0.0.0/0"]
}

output "run_name_out" {
  value = random_id.run_name.hex
}
output "ip" {
  value = google_compute_instance.compute.*.network_interface.0.access_config.0.nat_ip
}