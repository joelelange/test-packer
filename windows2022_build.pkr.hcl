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
  accelerator      = "hvf"                   # Using hvf for MacOS since KVM is not available
  communicator     = "winrm"
  cpus             = "4"
  disk_interface   = "ide"                   # not virtio-scsi or virtio as the virtio driver iso needs to be loaded first!
  disk_size        = "40960"                 # Size in MB, adjust as needed format = "qcow2"
  floppy_files     = ["scripts/autounattend.xml"]
  format           = var.qemu_format
  headless         = true                    # Set to false if you want a graphical console
  http_directory   = "/Users/joellange/local/apps"
  http_port_min    = "8801"
  http_port_max    = "8801"
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  machine_type     = "q35"
  memory           = "8192"
  net_device       = "e1000e"                 # not virtio-net, guess driver can't be loaded
  output_directory = var.output_directory
  #qemuargs         = [["-display", "cocoa"]] # This enables qemu-system-x86_64's builtin viewer popup!
  qemuargs         = [["-display", "none"]]
  vm_name          = "packer-win2022"
  winrm_insecure   = true
  winrm_use_ssl    = true
  winrm_timeout    = "1h"
  winrm_password   = "packer"
  winrm_username   = "Administrator"
  boot_command     = ["<spacebar>"]
  boot_wait        = "6m"
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

  provisioner "powershell" {
    inline = ["Invoke-WebRequest http://172.16.1.165:8801/GoogleChromeSE_131.msi -Outfile C:/Windows/Setup/Scripts/GoogleChromeSE_131.msi"]
  }

  provisioner "powershell" {
    inline = ["Invoke-WebRequest http://172.16.1.165:8801/OpenSSH-Client-Package~31bf3856ad364e35~amd64~~.cab -Outfile C:/Windows/Setup/Scripts/OpenSSH-Client-Package~31bf3856ad364e35~amd64~~.cab"]
  }

  provisioner "powershell" {
    inline = ["Invoke-WebRequest http://172.16.1.165:8801/OpenSSH-Server-Package~31bf3856ad364e35~amd64~~.cab -Outfile C:/Windows/Setup/Scripts/OpenSSH-Server-Package~31bf3856ad364e35~amd64~~.cab"]
  }

  # provisioner "powershell" {
  #   inline = ["Invoke-WebRequest http://172.16.1.165:8801/ProPlus2024Retail.zip -Outfile C:/Windows/Setup/Scripts/ProPlus2024Retail.zip"]
  # }

  # provisioner "powershell" {
  #   scripts = ["scripts/Enable-RDP.ps1"]
  # }

  # provisioner "powershell" {
  #   elevated_user     = "Administrator"
  #   elevated_password = build.Password
  #   scripts           = ["scripts/InstallOpenSSH.ps1"]
  # }

  # provisioner "powershell" {
  #   scripts = ["scripts/install-windows-updates.ps1"]
  # }

  # provisioner "windows-restart" {
  #   restart_timeout = "30m"
  # }

  # provisioner "powershell" {
  #   scripts = ["scripts/install-windows-updates.ps1"]
  # }

  # provisioner "windows-restart" {
  #   restart_timeout = "30m"
  # }

  # provisioner "powershell" {
  #   scripts = ["scripts/Enable-RDP.ps1"]
  # }

  # provisioner "powershell" {
  #   elevated_user     = "Administrator"
  #   elevated_password = build.Password
  #   scripts           = ["scripts/InstallOpenSSH.ps1"]
  # }

  provisioner "powershell" {
    scripts = ["scripts/InstallChrome.ps1"]
  }

  provisioner "windows-shell" {
    inline = ["C:/Windows/Setup/Scripts/SetupComplete.cmd"]
  }

  provisioner "powershell" {
    pause_before = "1m0s"
    scripts      = ["scripts/cleanup.ps1"]
  }
}