<#	
    .NOTES
    ===========================================================================
    Created on:   	10/02/2022
    Created by:   	Ryan Hogan
    Organization: 	Heartland Business Systems
    Filename:     	remove-sccmagent.ps1
    Version:        1.4 More Error Checking added by way of Functions
                     
    ===========================================================================
  
    .DESCRIPTION
    Thhis script uninstalls the SCCM Agent on a Windfows 10 or later device. 

#>
# Run SSCM remove

Function Remove-SCCM {
    # Stop Services if exist or started
    $ServiceNames = "CcmExec","smstsmgr","CmRcService"

Foreach ($service in $ServiceNames){
    if ($service.Status -eq 'Running'){
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    }
    else {}
}

# $ccmpath is path to SCCM Agent's own uninstall routine.
$CCMpath = 'C:\Windows\ccmsetup\ccmsetup.exe'
# And if it exists we will remove it, or else we will silently fail.
if (Test-Path $CCMpath) {
    Start-Process -FilePath $CCMpath -Args "/uninstall" -Wait -NoNewWindow
    
    # wait for exit
    $CCMProcess = Get-Process ccmsetup -ErrorAction SilentlyContinue
    try{
        $CCMProcess.WaitForExit()
        Remove-SCCMManually
    }
    catch{ Write-Host "SCCM uninstall failed, remove manually"
        Remove-SCCMManually
    }
 }
    RemovalCheck
 else { Write-Host "SCCM does not exist, continuing to Removal Check"
    RemovalCheck
    }
}
Function Remove-SCCMManually
{
# Remove WMI Namespaces
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='ccm'" -Namespace root | Remove-WmiObject
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='sms'" -Namespace root\cimv2 | Remove-WmiObject

# Remove Services from Registry
# Set $CurrentPath to services registry keys
$CurrentPath = "HKLM:\SYSTEM\CurrentControlSet\Services"
Remove-Item -Path $CurrentPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\CcmExec -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\smstsmgr -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\CmRcService -Force -Recurse -ErrorAction SilentlyContinue

# Remove SCCM Client from Registry
# Update $CurrentPath to HKLM/Software/Microsoft
$CurrentPath = "HKLM:\SOFTWARE\Microsoft"
Remove-Item -Path $CurrentPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\SMS -Force -Recurse -ErrorAction SilentlyContinue

# Reset MDM Authority
# CurrentPath should still be correct, we are removing this key: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DeviceManageabilityCSP
Remove-Item -Path $CurrentPath\DeviceManageabilityCSP -Force -Recurse -ErrorAction SilentlyContinue

# Remove Folders and Files
# Tidy up garbage in Windows folder
$CurrentPath = $env:WinDir
Remove-Item -Path $CurrentPath\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\ccmsetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\ccmcache -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\SMSCFG.ini -Force -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\SMS*.mif -Force -ErrorAction SilentlyContinue
Remove-Item -Path $CurrentPath\SMS*.mif -Force -ErrorAction SilentlyContinue 

}

Function RemovalCheck {
    
if (Test-Path $CCMpath) {
    Return 1603
}
 else { Return 0 }
}

Remove-SCCM