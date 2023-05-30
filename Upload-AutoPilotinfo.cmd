@echo on
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}" -ExecutionPolicy Bypass
powershell -Command "& {Install-PackageProvider NuGet -MinimumVersion 2.8.5.201 -Force}" -ExecutionPolicy Bypass
powershell -Command "& {Install-Script -name Get-WindowsAutopilotInfo -Force}"  -ExecutionPolicy Bypass
powershell -Command "& {set-executionpolicy RemoteSigned}"
powershell -Command "& {Get-WindowsAutopilotInfo.ps1 -Online -AddToGroup 'Autopilot-Hybrid Azure AD Joined' -Reboot}" -ExecutionPolicy Bypass
shutdown.exe /r /f /t 30 /c "Restarting the computer in 30 seconds due to a an Autopilot change."