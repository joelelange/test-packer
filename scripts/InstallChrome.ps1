# This will istall Google Chrome in C:\Windows\Temp\Setup\Scripts
$MSIInstallArguments = @("/i", "C:\Windows\Setup\Scripts\GoogleChromeSE_131.msi", "/norestart", "/quiet")
Start-Process "msiexec.exe" -ArgumentList $MSIInstallArguments -Wait -NoNewWindow