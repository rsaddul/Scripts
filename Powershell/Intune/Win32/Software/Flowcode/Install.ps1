# Install Flowcode
Start-Process -FilePath ".\E-blocks2_USB_Drivers\E-blocks2_64bit_installer.exe" -ArgumentList "/S" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath "Flowcode_Compiler_PICv2.msi" -ArgumentList "/quiet" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath "FlowcodeV9_Installer.msi" -ArgumentList "/quiet" -Wait -ErrorAction SilentlyContinue