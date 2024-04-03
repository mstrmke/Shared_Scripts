<#
    .NOTES
	===========================================================================
	 Created on:   	06/07/2023 13:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Uninstall-HPBloatware.ps1
	 Version: 	1.5 - Added Wilcards to Apx Bundles
	 			1.6 - Replaced Indivdual Apps with HP Win32 Product Uninstall Loop for all HP  Apps
				1.7 - Added Error Checking to all Uninstall Commands
	===========================================================================
    .DESCRIPTION
    This script manually removes an HP Bloatware on ENROLLED devices.
    
#>

#Remove HP Bloatware from Add/Remove Programs
# Get a list of all installed applications

$ErrorActionPreference = "SilentlyContinue"

try {
	Get-Package -Name "HP Wolf Security" | Uninstall-Package -AllVersions $ErrorActionPreference
	Write-Host "HP Wolf Security has been uninstalled." -ForegroundColor Green
}
catch {
	Write-Error "An error occurred: $_"
}

try {
	Get-Package -Name "*HP Wolf Security*" | Uninstall-Package -AllVersions $ErrorActionPreference
	Write-Host "Remaining components of HP Wolf Security has been uninstalled." -ForegroundColor Green
}
catch {
	Write-Error "An error occurred: $_" 
}

try {
	Start-Process "C:\Program Files (x86)\Hewlett-Packard\HP Support Framework\UninstallHPSA.exe" -ArgumentList "/s /v/qn UninstallKeepPreferences=FALSE" -Wait $ErrorActionPreference
	Write-Host "HP Support Asisstant has been uninstalled." -ForegroundColor Green
	
}
catch {
	Write-Error "An error occurred: $_" 
}

try {
	Get-Package -Name "*HP*" | Uninstall-Package -AllVersions $ErrorActionPreference
	Write-Host "All Remaining Applications of *HP* have been uninstalled." -ForegroundColor Green
}
catch {
	Write-Error "An error occurred: $_"
}


#Removing Unneeded HP AppX Bundles
$HPAppxPackages = Get-AppxPackage -Name *HP*

foreach ($HPAppxPackage in $HPAppxPackages)
{
	try {
		$HPAppxPackage | Remove-AppxPackage $ErrorActionPreference
		Write-Host "$HPAppxPackage has been uninstalled." -ForegroundColor Green
	}
	catch {
		Write-Error "An error occurred: $_" -ErrorAction Continue
	}
}