# Enable RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0

# Create firewall rule to allow RDP
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"