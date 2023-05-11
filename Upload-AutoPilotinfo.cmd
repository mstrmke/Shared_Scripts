@echo on
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"
powershell -Command "& {Install-PackageProvider NuGet -MinimumVersion 2.8.5.201 -Force}"
powershell -Command "& {Install-Script -name Get-WindowsAutopilotInfo -Force}"
powershell -Command "& {Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned}"
powershell -Command "& {Get-WindowsAutopilotInfo -Online -AddToGroup 'Autopilot-Hybrid Azure AD Joined' -Reboot -Assign}"