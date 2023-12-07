<#
    .NOTES
	===========================================================================
	 Created on:   	06/07/2023 13:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Uninstall-HPBloatware.ps1
	 Version: 	1.5 - Added Wilcards to Apx Bundles
	===========================================================================
    .DESCRIPTION
    This script manually removes an HP Bloatware on ENROLLED devices.
    
#>

(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security'} -ComputerName . ).Uninstall() -ErrorAction SilentlyContinue
(Get-WmiObject -Class Win32_Product -Filter {Name= -like "HP Wolf Security - Console"} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like "HP Wolf Security Application Support for Sure Sense"} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like "HP Wolf Security Application Support for Chrome"} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like "HP Notifications"} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like 'HP Security Update Service'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like 'HP System Default Settings'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like 'ICS'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like 'HP Sure Run Module'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name -like 'HP Documentation'} -ComputerName . ).Uninstall() 



#Removing Unneeded HP AppX Bundles
Get-AppxPackage -Name *myHP* | Remove-AppxPackage
Get-AppxPackage -Name *QuickDrop* | Remove-AppxPackage
Get-AppxPackage -Name *hpprivacysettings* | Remove-AppxPackage
Get-AppxPackage -Name *hpsysteminformation* | Remove-AppxPackage
Get-AppxPackage -Name *hpeasyclean* | Remove-AppxPackage
