
<#	
  .NOTES
  ===========================================================================
   Created on:   	10/02/2022
   Created by:   	Ryan Hogan
   Organization: 	Heartland Business Systems
   Filename:     	Rename-ADComputer.ps1
   Version:         2.2 Exit if Chassis Type is unknown
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
if (-not (Test-Path "$($env:ProgramData)\Microsoft\Rename-ADComputer"))
{
    Mkdir "$($env:ProgramData)\Microsoft\Rename-ADComputer"
}
Set-Content -Path "$($env:ProgramData)\Microsoft\Rename-ADComputer\Rename-ADComputer.ps1.tag" -Value "Renamed"

# Initialization
$dest = "$($env:ProgramData)\Microsoft\Rename-ADComputer"
if (-not (Test-Path $dest))
{
    mkdir $dest
}
Start-Transcript "$dest\Rename-ADComputer.log"

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
    
    If ($ChassisType -eq 7 -or $ChassisType -eq 8 -or $ChassisType -eq 9 -or $ChassisType -eq 10 -or $ChassisType -eq 14 -or $ChassisType -eq 15){
            $LaptopMachineName = "L$AssetTagNumber"
            
        Try {
            Rename-Computer -NewName "$LaptopMachineName" -Force -Confirm:$false
            Write-host "New PC Name is $LaptopMachineName; please reboot to complete process." 
            Return 0
         }
         Catch
        {
            Write-Host "Unable to rename computer, please reboot and try again."
            Return 1603
        }
    }
    Elseif ($ChassisType -eq 2 -or $ChassisType -eq 3 -or $ChassisType -eq 4 -or $ChassisType -eq 5 -or $ChassisType -eq 6){
        $DesktopMachineName = "D$AssetTagNumber"
        Try {
            Rename-Computer -NewName "$DesktopMachineName" -Force -Confirm:$false
            Write-host "New PC Name is $DesktopMachineName; please reboot to complete process." 
            Return 0
         }
         Catch
        {
            Write-Host "Unable to rename computer, please reboot and try again."
            Return 1603
        }
    }
       
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
        Write-Warning "Computer is pending a reboot. Please do so and rerun script."
        Exit 1641
    } else {
        $false
        DomainCheck
    }
}

$AssetTagNumber = (Get-WmiObject -class win32_bios).Serialnumber
$ChassisType = (Get-WmiObject -class Win32_SystemEnclosure).chassistypes
If ($ChassisType -eq 0){
    Write-out "Chassis Type is unknown, Exiting"
    Exit 1603
}   
Else {CheckRebootStatus}


Stop-Transcript