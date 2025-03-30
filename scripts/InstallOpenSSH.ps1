# Adding SSH client and SSH server to Windows Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -source C:\Windows\Setup\Scripts
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0 -source C:\Windows\Setup\Scripts

# Configuring ssh-agent service and sshd service to automatically start
Set-Service -Name ssh-agent -StartupType 'Automatic'
Set-Service -Name sshd -StartupType 'Automatic'

# Lastly start the relevant services
Start-Service ssh-agent
Start-Service sshd