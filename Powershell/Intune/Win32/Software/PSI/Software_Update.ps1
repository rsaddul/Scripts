# Uninstall PSI Bridge Secure Browser
Start-Process -FilePath "C:\Program Files\psi-bridge-secure-browser\Uninstall PSI Bridge Secure Browser.exe" -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath "C:\Program Files\PSI Bridge Secure Browser\Uninstall PSI Bridge Secure Browser.exe" -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath "C:\users\public\psi-bridge-secure-browser\Uninstall PSI Bridge Secure Browser.exe" -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\psi-bridge-secure-browser" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\PSI Bridge Secure Browser" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Roaming\PSI Bridge Secure Browser" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Roaming\com.psiexams.psi-bridge-secure-browser" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Local\psi-bridge-secure-browser-updater" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PSI Bridge Secure Browser.lnk" -Force -ErrorAction SilentlyContinue

# Delete firewall rules
Remove-NetFirewallRule -DisplayName "psi bridge secure browser.exe" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "PSI Bridge Secure Browser" -ErrorAction SilentlyContinue

# Install New PSI Bridge Secure Browser
Start-Process -FilePath "production_PSI-SecureBrowserSetup-2.7.2.msi" -ArgumentList "/quiet" -Wait -ErrorAction SilentlyContinue

# Add TCP inbound rule
New-NetFirewallRule -DisplayName "PSI Bridge Secure Browser TCP" -Description "PSI Bridge Secure Browser TCP" -Direction Inbound -Program "C:\users\public\psi bridge secure browser\psi bridge secure browser.exe" -LocalPort Any -Protocol TCP -Profile Domain,Private -Action Allow

# Add UDP inbound rule
New-NetFirewallRule -DisplayName "PSI Bridge Secure Browser UDP" -Description "PSI Bridge Secure Browser UDP" -Direction Inbound -Program "C:\users\public\psi bridge secure browser\psi bridge secure browser.exe" -LocalPort Any -Protocol UDP -Profile Domain,Private -Action Allow