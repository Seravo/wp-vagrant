# Virtual machine
vm_name     = "seravo-wordpress"
#vm_hostname = "seravo-wordpress"
vm_cpus     = 2
vm_memory   = 2048

# Installation media
iso_path          = "build/.cache/ubuntu-20.04.iso"
iso_url           = "https://releases.ubuntu.com/focal/ubuntu-20.04.6-live-server-amd64.iso"
iso_checksum      = "b8f31413336b9393ad5d8ef0282717b2ab19f007df2e9ed5196c13d8f9153c8b"
iso_checksum_type = "sha256"

# Communicator
ssh_username = "vagrant"
ssh_password = "vagrant"