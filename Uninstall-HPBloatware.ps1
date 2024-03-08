<#
    .NOTES
	===========================================================================
	 Created on:   	06/07/2023 13:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Uninstall-HPBloatware.ps1
	 Version: 	1.5 - Added Wilcards to Apx Bundles
	 			1.6 - Replaced Indivdual Apps with HP Win32 Product Uninstall Loop for all HP  Apps
	===========================================================================
    .DESCRIPTION
    This script manually removes an HP Bloatware on ENROLLED devices.
    
#>

#Remove HP Bloatware from Add/Remove Programs
# Get a list of all installed applications

Get-package -Name "HP Wolf Security"| Uninstall-package -AllVersions -ErrorAction SilentlyContinue
Get-package -Name "*HP Wolf Security*"| Uninstall-package -AllVersions -ErrorAction SilentlyContinue
Start-Process "C:\Program Files (x86)\Hewlett-Packard\HP Support Framework\UninstallHPSA.exe" -ArgumentList "/s /v/qn UninstallKeepPreferences=FALSE"
Get-package -Name "*HP*"| Uninstall-package -AllVersions -ErrorAction SilentlyContinue

#Removing Unneeded HP AppX Bundles
$HPAppxPackages = Get-AppxPackage -Name *HP*

foreach ($HPAppxPackage in $HPAppxPackages)
{
	$HPAppxPackage | Remove-AppxPackage -ErrorAction SilentlyContinue
}