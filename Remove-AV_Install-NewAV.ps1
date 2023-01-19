<#
    .NOTES
	===========================================================================
	 Created on:   	01/19/2023 16:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Install-Defender_UninstallAV.ps1
	 Version: 0.1.0 - 01/19/2023 - Initial Version
	===========================================================================
    .DESCRIPTION
		This script confoigures BizTalk server for the 3E environment. It does not install or Configure the ESB for Biztalk. 
		The script will walk prompt for continuation when manual steps need to be completed (See Installer Checklist)
#>


$OSType = "$(((gcim Win32_OperatingSystem).Name).split(‘|’)[0])"

$Path = "<Path to Antivirus client service executable>"
If ($Path)
{
   #Uninstall Antivirus
(Get-WmiObject -Class Win32_Product -Filter {Name='<Antivirus name in Add/Remove Programs>'} -ComputerName . ).Uninstall()
}

Else { 
   start-process "cmd.exe" "/c "<.exe of new AV with any switches>"
   
   #If using MSI (Uncomment below and comment the command above)
   #start-process "msiexec.exe /i "<Path of MSI setup>" /noreboot /qn
    
    Write-Output "AV Client already uninstalled, New Antivirus Installed"
}

Exit $LASTEXITCODE
