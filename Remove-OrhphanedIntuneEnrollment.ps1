<#
    .NOTES
	===========================================================================
	 Created on:   	06/07/2023 13:28
	 Created by:   	Ryan Hogan
	 Organization: 	Heartland Business Systems
	 Filename:     	Remove-OrphanedIntuneEnrollment.ps1
	 Version: 		1.0 - Initial Version
	===========================================================================
    .DESCRIPTION
    This script manually removes a orhpnaed device from InTune. Meaning The Device is alreday removed from InTune. 
    
#>

#Copy Enterprise MGMT GUID
$EnterpriseMGMTGUID = Read-Host "Copy and Enter GUID from Task Scheduler > Library > Microsoft > Windows >  EnterpriseMGMT"
#Remove EnterpsieMGMT tasks and GUID folder

try {
    Get-ScheduledTask -TaskPath "\Microsoft\Windows\EnterpriseMgmt\$EnterpriseMGMTGUID\*" | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item  -Path "$env:windir\System32\Tasks\Microsoft\Windows\EnterpriseMGMT\$EnterpriseMGMTGUID" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Microsoft\Windows\EnterpriseMgmt\$EnterpriseMGMTGUID" -Force -Confirm:$false


    #Remove InTune Certificate  
    Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.IssuerName.Name -match 'Microsoft Intune MDM Device CA' } | Remove-Item -ErrorAction SilentlyContinue

    #Remove Registry key. GUID only match Key name
    Remove-Item HKLM:\SOFTWARE\Microsoft\Enrollments\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\Enrollments\Status\$EnterpriseMGMTGUID -Recurse -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions\$EnterpriseMGMTGUID -Recurse -Force -ErrorAction SilentlyContinue

    #Run GPupdate
    Invoke-GPUpdate -Target "Computer"
    Write-host "Orphaned Intune Enrollment has been removed, please reboot computer and have user log in"
}
Catch { Write-Host "Error in Orphan Removal, please restart computer and try again."}