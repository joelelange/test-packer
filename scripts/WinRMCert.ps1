#Remove the self-signed certificate and add it back after sysprep
get-childitem Cert:\LocalMachine\My\ -DnsName "WinRMCertificate" | Remove-Item
IF (!(get-childitem Cert:\LocalMachine\My\)) `
{ New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "WinRMCertificate"}
($cert = gci Cert:\LocalMachine\My\) -and `
(Set-WSManInstance -ResourceURI winrm/config/listener -SelectorSet `
@{Address="*";Transport="https"} -ValueSet @{CertificateThumbprint=$cert.Thumbprint})