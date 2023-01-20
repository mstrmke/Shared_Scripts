<#
    .NOTES
	===========================================================================
	 Created on:   	01/19/2023 16:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Remove-AV_Install-NewAV.ps1
	 Version: 		0.2.0 - 01/19/2023 - Moved Uninstall and Install to their own Functions. 
	 				0.1.2 - 01/19/2023 - Moved Try/Catch out of Else statement 
	 				0.1.1 - 01/19/2023 - Added two AV component paths to check and Try/Catch for install to report error
	 				0.1.0 - 01/19/2023 - Initial Version
	===========================================================================
    .DESCRIPTION
		This script uninstalls a current Antivirus, if exists, and installs a new Antivirus from the command desired. 
#>

Function UninstallOldAV{

	#Call Full Paths to AV Service executables, ex: C:\SEP\someexecutable.exe
	$PathToAV = "<Path to Antivirus1 service executable>","<Path to Antivirus2 service executable>"


	foreach ($Path in $PathToAV){
	
		If (Test-Path -path $Path -PathType Leaf)
		{
   			Try{
				#Uninstall Antivirus1
				(Get-WmiObject -Class Win32_Product -Filter {Name='<Antivirus1 name in Add/Remove Programs>'} -ComputerName . ).Uninstall()
			}
			Catch {
				(Get-WmiObject -Class Win32_Product -Filter {Name='<Antivirus2 name in Add/Remove Programs>'} -ComputerName . ).Uninstall()
			}	
		}

		Else {}
	}
	Write-Output "Old AV Client was already uninstalled, Installing New AV"
}
Function InstallNewAV {
	Try
	{
		#Inastall New AV, ex: C:\Temp\Antivirus.msi (No Spaces in path)
		start-process msiexec.exe -Wait -ArgumentList '/i <Path of MSI setup> /noreboot /qn'
   		Write-Output "New Antivirus Installed Succesfully"
	}
	Catch 
	{
		Write-Output "Error in Antivirus Install. Detail: $Error[0]"
	}
}


UninstallOldAV
InstallNewAV