#3#####################
# Variable definitions
#######################

variable "version" {
  type        = string
  description = "The version of the Vagrant box."
  default     = ""
}

variable "headless" {
  type        = bool
  description = "The version of the Vagrant box."
  default     = true
}

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine."
  default     = ""
}

variable "vm_cpus" {
  type        = number
  description = "The number of cpus to use for building the VM."
  default     = 1
}

variable "vm_memory" {
  type        = number
  description = "The amount of memory to use for building the VM in megabytes."
  default     = 512
}

variable "iso_path" {
  type        = string
  description = "The path of the ISO installation media."
  default     = ""
}

variable "iso_url" {
  type        = string
  description = "The URL of the ISO installation media."
  default     = ""
}

variable "iso_checksum" {
  type        = string
  description = "The checksum of the ISO installation media."
  default     = ""
}

variable "iso_checksum_type" {
  type        = string
  description = "The type of the ISO installation media checksum."
  default     = ""
}

variable "ssh_username" {
  type        = string
  description = "The username of the default user for SSH."
  default     = ""
}

variable "ssh_password" {
  type        = string
  description = "The username of the default user for SSH."
  default     = ""
}

##################
# Local variables
##################

locals {
  semver  = "${formatdate("YYYYMMDD", timestamp())}.0.0"
  version = "${var.version != "" ? var.version : local.semver}"
  vm_name = "${var.vm_name}_${local.version}"
}


source "virtualbox-iso" "ubuntu-server" {
  # Virtual machine
  vm_name          = "${local.vm_name}"
  headless         = "${var.headless}"
  guest_os_type    = "Ubuntu_64"
  output_directory = "build/${var.vm_name}"
  output_filename  = "${local.vm_name}"
  vboxmanage       = [
    ["modifyvm", "${local.vm_name}", "--audio",    "none"            ],
    ["modifyvm", "${local.vm_name}", "--usb",      "off"             ],
    ["modifyvm", "${local.vm_name}", "--vram",     "12"              ],
    ["modifyvm", "${local.vm_name}", "--vrde",     "off"             ],
    ["modifyvm", "${local.vm_name}", "--nictype1", "virtio"          ],
    ["modifyvm", "${local.vm_name}", "--cpus",     "${var.vm_cpus}"  ],
    ["modifyvm", "${local.vm_name}", "--memory",   "${var.vm_memory}"],
  ]

  # Installation media
  iso_urls             = ["${var.iso_path}", "${var.iso_url}"]
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_target_path      = "${var.iso_path}"
  iso_target_extension = "iso"

  # Communicator
  communicator           = "ssh"
  ssh_port               = 22
  ssh_username           = "${var.ssh_username}"
  ssh_password           = "${var.ssh_password}"
  ssh_timeout            = "30m"
  ssh_handshake_attempts = "100000"

  # Boot command
  boot_wait    = "5s"
  boot_command = [
    "<esc><esc><esc><enter><wait>",
    "/casper/vmlinuz",
    " root=/dev/sr0",
    " initrd=/casper/initrd",
    " autoinstall",
    " ds=nocloud-net;",
    " <enter>",
  ]

  # Shutdown command
  shutdown_command = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout = "15m"
}


build {
  sources = ["virtualbox-iso.ubuntu-server"]
}
