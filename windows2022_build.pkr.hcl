# Variables
variable "iso_url" {
  default = "file:///Users/joellange/Desktop/ISOs/WindowsServer/SERVER_EVAL_x64FRE_en-us.iso"
}

variable "iso_checksum" {
  default = "md5:e7908933449613edc97e1b11180429d1"
}

variable "iso_checksum_type" {
  default = "md5"
}

variable "qemu_format" {
  default = "qcow2"
}

variable "output_directory" {
  default = "output-windows-qcow2"
}

variable "virtio_iso_path" {
  default = "file:///Users/joellange/Desktop/ISOs/virtio-win-0.1.266.iso"
}

packer {
  required_plugins {
    qemu = {
      #version = "~> 1"
      version = "1.1.1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

# Source block for QEMU builder
source "qemu" "windows" {
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  output_directory = var.output_directory
  machine_type     = "q35"
  disk_size        = "40960" # Size in MB, adjust as needed format = "qcow2"
  accelerator      = "hvf"   # Using hvf for MacOS since KVM is not available
  vm_name          = "packer-win2022"
  format           = var.qemu_format
  headless         = false # Set to false if you want a graphical console
  memory           = "4096"
  cpus             = "2"
  net_device       = "e1000e"                # not virtio-net, guess driver can't be loaded
  disk_interface   = "ide"                   # not virtio-scsi or virtio as the virtio driver iso needs to be loaded first!
  qemuargs         = [["-display", "cocoa"]] # This enables qemu-system-x86_64's builtin viewer popup!
  communicator     = "winrm"
  winrm_insecure   = true
  winrm_use_ssl    = true
  winrm_timeout    = "1h"
  winrm_password   = "packer"
  winrm_username   = "Administrator"
  floppy_files     = ["scripts/autounattend.xml"]
  boot_command     = ["<spacebar>"]
  boot_wait        = "6m10s"
  shutdown_command = "shutdown /s /t 0"
}

# Build block to execute the source
build {
  sources = [
    "source.qemu.windows"
  ]

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  provisioner "file" {
    source      = "scripts/autounattend.xml"
    destination = "C:/Windows/Panther/autounattend.xml"
  }

  provisioner "file" {
    source      = "scripts/WinRMCert.ps1"
    destination = "C:/Windows/Setup/Scripts/WinRMCert.ps1"
  }

  provisioner "file" {
    source      = "scripts/SetupComplete.cmd"
    destination = "C:/Windows/Setup/Scripts/SetupComplete.cmd"
  }

  # provisioner "powershell" {
  #   scripts = ["scripts/Enable-RDP.ps1"]
  # }

  # provisioner "powershell" {
  #   elevated_user     = "Administrator"
  #   elevated_password = build.Password
  #   scripts           = ["scripts/InstallOpenSSH.ps1"]
  # }

  provisioner "powershell" {
    scripts = ["scripts/install-windows-updates.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/install-windows-updates.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "windows-shell" {
    inline = ["C:/Windows/Setup/Scripts/SetupComplete.cmd"]
  }

  provisioner "powershell" {
    pause_before = "1m0s"
    scripts      = ["scripts/cleanup.ps1"]
  }
}