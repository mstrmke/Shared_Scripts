rem version 1.4 - For Hybrid Azure AD Joined Devices. Change "Intune_Autopilot-HAADJ" to the Hybrid Azure AD Domain Configuration Profile Group in InTune
@echo on
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}" -ExecutionPolicy Bypass
powershell -Command "& {Install-PackageProvider NuGet -MinimumVersion 2.8.5.201 -Force}" -ExecutionPolicy Bypass
powershell -Command "& {Install-Script -name Get-WindowsAutopilotInfo -Force}"  -ExecutionPolicy Bypass
powershell -Command "& {set-executionpolicy RemoteSigned}"

powershell.exe -file "C:\Program Files\WindowsPowerShell\Scripts\Get-WindowsAutoPilotInfo.ps1" -Online -AddToGroup "Intune_Autopilot-HAADJ" -Assign
