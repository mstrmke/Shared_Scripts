@echo on
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}" -ExecutionPolicy Bypass
powershell -Command "& {Install-PackageProvider NuGet -MinimumVersion 2.8.5.201 -Force}" -ExecutionPolicy Bypass
timeout /t 20 /nobreak
powershell -Command "& {Install-Script -name Get-WindowsAutopilotInfo -Force}"  -ExecutionPolicy Bypass
powershell -Command "& {set-executionpolicy RemoteSigned}"
powershell -Command "& {Get-WindowsAutopilotInfo.ps1 -Online -AddToGroup 'Autopilot-Hybrid Azure AD Joined' -Reboot}"
