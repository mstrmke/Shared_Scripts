@echo on
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12" -ExecutionPolicy Bypass
powershell -Command "Install-PackageProvider NuGet -MinimumVersion 2.8.5.201 -Force" -ExecutionPolicy Bypass
powershell -Command "Install-Script -name Get-WindowsAutopilotInfo -Force"  -ExecutionPolicy Bypass
powershell -Command "set-executionpolicy -ExecutionPolicy RemoteSigned"
powershell -Command "Get-WindowsAutopilotInfo.ps1 -Online -Reboot"
