<#
    .NOTES
	===========================================================================
	 Created on:   	01/19/2023 16:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Remove-AV_Install-NewAV.ps1
	 Version: 	0.1.1 - 01/19/2023 - Added two AV component paths to check and Try/Catch for install to report error
	 		0.1.0 - 01/19/2023 - Initial Version
	===========================================================================
    .DESCRIPTION
		This script uninstalls a current Antivirus, if exists, and installs a new Antivirus from the command desired. 
#>

$PathToAV1 = "<Path to Antivirus SentinalOne service executable>"
$PathToAV2 = "<Path to Antivirus2 Webroot service executable>"

If ($PathToAV1)
{
   	#Uninstall Antivirus1
	(Get-WmiObject -Class Win32_Product -Filter {Name='<Antivirus name in Add/Remove Programs>'} -ComputerName . ).Uninstall()
}

ElseIf ($PathToAV2)
{
	#Uninstall Antivirus2
	(Get-WmiObject -Class Win32_Product -Filter {Name='<Antivirus name in Add/Remove Programs>'} -ComputerName . ).Uninstall()
}
Else {
   	Try
	{
	#Inastall New AV
	#start-process "cmd.exe" "/c "<.exe of new AV with any switches>"
   
   	#If using MSI (Uncomment below and comment the command above)
   	start-process "msiexec.exe /i "<Path of MSI setup>" /noreboot /qn
   
   	Write-Output "Old AV Client was already uninstalled, New Antivirus Installed Succesfully"
	}
	Catch 
	{
		Write-Output "Error in BitDefender Install, [Error].0"
	}
}

Exit $LASTEXITCODE
