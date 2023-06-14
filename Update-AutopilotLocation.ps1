<#	
  .NOTES
  ===========================================================================
   Created on:   	06/04/2023
   Created by:   	Ryan Hogan
   Organization: 	Heartland Business Systems
   Filename:     	Update-AutopilotLocation.ps1
   Version:         	1.0 (Initial Version)
   			1.1 - Remove AppX Bundle removal as it is not related. 
  ===========================================================================
  
  .DESCRIPTION
    This script set the location to enabled so that the time zone is current. It also Removes any Windows Applications that are installed by Default. 
 

#>

Create a tag file just so Intune knows this was installed
if (-not (Test-Path "$($env:ProgramData)\Microsoft\AutopilotBranding"))
{
    Mkdir "$($env:ProgramData)\Microsoft\AutopilotBranding"
}
Set-Content -Path "$($env:ProgramData)\Microsoft\AutopilotBranding\AutopilotBranding.ps1.tag" -Value "Installed"

# Start logging
Start-Transcript "$($env:ProgramData)\Microsoft\AutopilotBranding\AutopilotBranding.log"


	# Enable location services so the time zone will be set automatically (even when skipping the privacy page in OOBE) when an administrator signs in
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type "String" -Value "Allow" -Force
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type "DWord" -Value 1 -Force
	Start-Service -Name "lfsvc" -ErrorAction SilentlyContinue
