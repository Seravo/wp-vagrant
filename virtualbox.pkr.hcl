variable "version" {
  default = "0"
}
variable "iso_path" {
  default = "build/.cache/ubuntu-18.04.6-server-amd64.iso"
}
variable "iso_url" {
  default = "https://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.6-server-amd64.iso"
}
variable "iso_checksum" {
  default = "f5cbb8104348f0097a8e513b10173a07dbc6684595e331cb06f93f385d0aecf6"
}
variable "headless" {
  default = true
}

source "virtualbox-iso" "ubuntu1804" {
  // VM config
  vm_name                 = "seravo-wordpress_${var.version}"
  guest_os_type           = "Ubuntu_64"
  cpus                    = 2
  memory                  = 2048
  disk_size               = 8192
  usb                     = false
  sound                   = null
  nic_type                = "virtio"
  hard_drive_interface    = "ide"
  gfx_vram_size           = 12
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--vrde", "off"]]
  // ISO config
  iso_urls                = ["${var.iso_path}", "${var.iso_url}"]
  iso_checksum            = "sha256:${var.iso_checksum}"
  iso_target_path         = "${var.iso_path}"
  // Run config
  headless                = "${var.headless}"
  // Build config
  ssh_password            = "vagrant"
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "1200s"
  http_directory          = "http"
  output_directory        = "build/virtualbox"
  output_filename         = "seravo-wordpress_${var.version}"
  shutdown_command        = "echo 'vagrant' | sudo -S shutdown -P now"
  boot_command            = [
    "<esc><esc><enter><wait>",
    "/install/vmlinuz",
    " initrd=/install/initrd.gz",
    " auto=true",
    " priority=critical",
    " locale=en_US",
    " live-installer/enable=false",
    " url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg",
    " --- <enter>"
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu1804"]

  provisioner "file" {
    sources = [
      "vagrant/files/avahi-services/http.service",
      "vagrant/files/avahi-services/ssh.service",
      "vagrant/files/avahi-services/rc.local",
      "vagrant/files/controller/seravo-controller.service",
      "vagrant/files/controller/delay.conf",
      "vagrant/files/controller/sc.sh",
      "vagrant/files/commands/wp-wrapper",
      "vagrant/files/commands/wp-wrapper-noop",
      "vagrant/files/commands/wp-wrapper-interactive",
    ]
    destination = "/home/vagrant/"
  }

  provisioner "shell" {
    execute_command = "sudo bash -e {{ .Path }}"
    scripts         = [
      "scripts/10-ssh.sh",
      "scripts/20-files.sh",
      "scripts/30-docker.sh",
      "scripts/90-cleanup.sh"
    ]
  }

  post-processors {
    post-processor "artifice" {
      files = [
        "build/virtualbox/seravo-wordpress_${var.version}-disk001.vmdk",
        "build/virtualbox/seravo-wordpress_${var.version}.ovf",
      ]
    }

    post-processor "vagrant" {
      compression_level              = 9
      provider_override              = "virtualbox"
      output                         = "build/virtualbox/seravo-wordpress_${var.version}.box"
    }
  }
}
