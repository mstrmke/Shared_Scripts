
<#	
  .NOTES
  ===========================================================================
   Created on:   	10/02/2022
   Created by:   	Ryan Hogan
   Organization: 	Heartland Business Systems
   Filename:     	Rename-ComputerByAssignedUser.ps1
   Version:         1.0 (Initial Version)
  ===========================================================================
  
  .DESCRIPTION
    This script uses an AD User's name (typed in) and renames a computer to the requested Prefix followed by that username. 
 

#>

Param()
Function DomainCheck
{

# If we are running as a 32-bit process on an x64 system, re-launch as a 64-bit process
if ("$env:PROCESSOR_ARCHITEW6432" -ne "ARM64")
{
    if (Test-Path "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe")
    {
        & "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy bypass -File "$PSCommandPath"
    }
}

# Create a tag file just so Intune knows this was installed
if (-not (Test-Path "$($env:ProgramData)\Microsoft\Rename-ComputerByAssignedUser"))
{
    Mkdir "$($env:ProgramData)\Microsoft\Rename-ComputerByAssignedUser"
}
Set-Content -Path "$($env:ProgramData)\Microsoft\Rename-ComputerByAssignedUser\Rename-ComputerByAssignedUser.ps1.tag" -Value "Installed"

# Initialization
$dest = "$($env:ProgramData)\Microsoft\Rename-ComputerByAssignedUser"
if (-not (Test-Path $dest))
{
    mkdir $dest
}
Start-Transcript "$dest\Rename-ComputerByAssignedUser.log" -Append

# Make sure we are already domain-joined
$details = Get-ComputerInfo

if (-not $details.CsPartOfDomain)
{
    Write-Host "Not part of a domain."
    Exit 1603
}

# Make sure we have connectivity
$dcInfo = [ADSI]"LDAP://DC=HBS,DC=NET" #FQDN of Domain
if ($dcInfo.distinguishedName -eq $null)
{
    Write-Host "No connectivity to the domain."
    Exit 1603
}
goodToGo
}

Function goodToGo
{
    $Username = Read-Host "Enter Username for Primary Assigned User"
    
    Try
    { 
        Rename-Computer -NewName "HBS-$Username" -Force
        Write-host "New PC Name is 'HBS-$Username;, pelase reboot to complete process." 
        Return 0
    }
    Catch
    {
        Write-Host "Unable to rename computer, please reboot and try again."
        Return 1603
    }

    # Remove the scheduled task
    Disable-ScheduledTask -TaskName "Rename-ComputerByAssignedUser" -ErrorAction Ignore
    Unregister-ScheduledTask -TaskName "Rename-ComputerByAssignedUser" -Confirm:$false -ErrorAction Ignore
    Write-Host "Scheduled task unregistered."

}
else
{
    # Check to see if already scheduled
    $existingTask = Get-ScheduledTask -TaskName "Rename-ComputerByAssignedUser" -ErrorAction SilentlyContinue
    if ($existingTask -ne $null)
    {
        Write-Host "Scheduled task already exists."
        Stop-Transcript
        Exit 0
    }

    # Copy myself to a safe place if not already there
    if (-not (Test-Path "$dest\Rename-ComputerByAssignedUser.ps1"))
    {
        Copy-Item $PSCommandPath "$dest\Rename-ComputerByAssignedUser.PS1"
    }

Function CheckRebootStatus{
$pendingRebootTest = @(
    @{
        Name = 'RebootRequired'
        Test = { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'  Name 'RebootRequired' -ErrorAction Ignore }
        TestType = 'ValueExists'
    }
)
if ($pendingRebootTest.TestType -eq 'ValueExists' -and $result) {
        $true
        Write-Warning "Computer is pending a reboot. Please do so and rerun script."
    } elseif ($pendingRebootTest.TestType -eq 'NonNullValue' -and $result -and $result.($pendingRebootTest.Name)) {
        $true
        Exit 1641
        Write-Warning "Computer is pending a reboot. Please do so and rerun script."
        Exit 1641
    } else {
        $false
        DomainCheck
    }
}
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber

CheckRebootStatus
Stop-Transcript