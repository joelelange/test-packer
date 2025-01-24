netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In)" new action=allow
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
powershell -File C:\Windows\Setup\Scripts\WinRMCert.ps1
del C:\Windows\Panther\autounattend.xml