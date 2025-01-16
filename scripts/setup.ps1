# Setting view options
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideDrivesWithNoMedia" 0
Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 0


# Disable hibernation
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\" -Name "HiberFileSizePercent" -Value 0
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\" -Name "HibernateEnabled" -Value 0

# Hide Edge first run experience
New-Item "HKLM:\Software\Policies\Microsoft\Edge"  
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge\" -Name "HideFirstRunExperience" -Value 1 -PropertyType DWORD

# Disable sleep
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0

#set to the highperformance profile
powercfg /setactive DED574B5-45A0-4F42-8737-46345C09C238

# Disable password expiration for Administrator.  CAUTION: Typically, you'll override this setting with a group policy once the machine is added to a domain.
Set-LocalUser Administrator -PasswordNeverExpires $true