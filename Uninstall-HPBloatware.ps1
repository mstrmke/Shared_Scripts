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
$HPInstalledApps = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -like "*HP*"}

foreach ($HPInstalledApp in $HPInstalledApps)
{
	$HPWin32Product.Uninstall()
}

#Removing Unneeded HP AppX Bundles
$HPAppxPackages = Get-AppxPackage -Name *HP*

foreach ($HPAppxPackage in $HPAppxPackages)
{
	$HPAppxPackage | Remove-AppxPackage
}
