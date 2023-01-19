<#
    .NOTES
	===========================================================================
	 Created on:   	11/24/2022 5:28 PM
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Install-Defender_UninstallAV.ps1
	 Version: 0.1.2 - 12/15/2022 - Adding $LASTEXITCODE to return code to Intune
              0.1.1 - 11/28/2022 - Putting in if/else statement to search for OS version
              0.1.0 - 11/24/2022 - Initial Version
	===========================================================================
    .DESCRIPTION
		This script confoigures BizTalk server for the 3E environment. It does not install or Configure the ESB for Biztalk. 
		The script will walk prompt for continuation when manual steps need to be completed (See Installer Checklist)
#>


$OSType = "$(((gcim Win32_OperatingSystem).Name).split(‘|’)[0])"

#Uninstall Antivirus
(Get-WmiObject -Class Win32_Product -Filter {Name='<Antivirus name in Add/Remove Programs>'} -ComputerName . ).Uninstall()

#If OS Name is Server 2012 (or R2), Server 2016, or Windows 7, install Defender Agent. 
#Windows 10/11 and Server 2019/2022 already have the agent embeedded in the system
If ($OSType.Contains("Server 2016") -or $OSType.Contains("Server 2012") -or $OSType.Contains("7"))
{
    msiexec.exe /i "\\<FQDN>\SYSVOL\Scripts\md4ws.msi" /qn
    start-process "cmd.exe" "/c %PATHTOONBOARDINGSCRIPT%"
    Write-Output "AV Client unisntalled, Defender Agent was installed and onboarded"
}

Else { 
    start-process "cmd.exe" "/c <ONBOARDINGSCRIPTFULLPATH>"
    Write-Output "AV Client unisntalled, Defender Agent not needed for this OS but has been onboarded"
}

Exit $LASTEXITCODE
