
<#	
  .NOTES
  ===========================================================================
   Created on:   	05/12/2023
   Created by:   	Ryan Hogan
   Organization: 	Heartland Business Systems
   Filename:     	Rename-ComputerBasedOffIP.ps1
   Version:         1.0 (Initial Version)
                    1.1 Removed Scheduled Task and putting tagged file in new "mem" folder. 
  ===========================================================================
  
  .DESCRIPTION
    This script uses a WMI object call to get the IP address and rename a computer to the requested Prefix followed by the machines Serial Number. 
 

#>

Param()
Function Precheck
{

# Create a tag file just so Intune knows this was installed
if (-not (Test-Path "$($env:ProgramData)\mem\Rename-ComputerBasedOffIP"))
{
    Mkdir "$($env:ProgramData)\mem\Rename-ComputerBasedOffIP"
}

Set-Content -Path "$($env:ProgramData)\mem\Rename-ComputerBasedOffIP\Rename-ComputerBasedOffIP.ps1.tag" -Value "Renamed"

# Initialization
$dest = "$($env:ProgramData)\mem\Rename-ComputerBasedOffIP"
if (-not (Test-Path $dest))
{
    mkdir $dest
}
Start-Transcript -Path "$env:ProgramData)\mem\Rename-ComputerBasedOffIP_$ReanmeDate.log" -Append

# Make sure we are already domain-joined
$details = Get-ComputerInfo

if (-not $details.CsPartOfDomain)
{
    Write-Host "Not part of a domain."
    Exit 1603
}

# Make sure we have connectivity
if (!(Test-ComputerSecureChannel)) {

    Write-Host "No connectivity to the domain."
    Exit 1603
}
goodToGo
}

Function goodToGo
{
    #WMI Command to exclude if a laptop Azure AD grooup "RSD Laptops"
    If ($details.CsPCSystemType -eq "Mobile")
    {
        Write-Host "This is a laptop, I will generate the LT-$SerialNumber PC Name."
        Try {
            Rename-Computer -NewName "LT-$SerialNumber" -Force
            Write-host "New PC Name is 'LT-$SerialNumber'" 
            Return 0
            Restart-Computer
            
        }
        Catch {Exit 1603}
    }

    ElseIf ($IPAddress -like "10.102.*.*" )
    { 
        Rename-Computer -NewName "AD-$SerialNumber" -Force
        Write-host "New PC Name is 'AD-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.103.*.*" )
    { 
        Rename-Computer -NewName "RHS-$SerialNumber" -Force
        Write-host "New PC Name is 'RHS-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.104.*.*" )
    {    
        Rename-Computer -NewName "HHS-$SerialNumber" -Force
        Write-host "New PC Name is 'HHS-$SerialNumber'" 
        Return 0
    }
<#    Removing TECH for imaging Process. 
        Elseif ($IPAddress -like "10.105.*.*" )
    { 
        Rename-Computer -NewName "TECH-$SerialNumber" -Force
        Write-host "New PC Name is 'TECH-$SerialNumber'" 
        Return 0
    }
    #>
    Elseif ($IPAddress -like "10.106.*.*" )
    { 
        Rename-Computer -NewName "EW-$SerialNumber" -Force
        Write-host "New PC Name is 'EW-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.107.*.*" )
    { 
        Rename-Computer -NewName "GL-$SerialNumber" -Force
        Write-host "New PC Name is 'GL-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.108.*.*" )
    { 
        Rename-Computer -NewName "OD-$SerialNumber" -Force
        Write-host "New PC Name is 'OD-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.109.*.*" )
    { 
        Rename-Computer -NewName "FT-$SerialNumber" -Force
        Write-host "New PC Name is 'FT-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.110.*.*" )
    { 
        Rename-Computer -NewName "BG-$SerialNumber" -Force
        Write-host "New PC Name is 'BG-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.111.*.*" )
    { 
        Rename-Computer -NewName "ES-$SerialNumber" -Force
        Write-host "New PC Name is 'ES-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.112.*.*" )
    { 
        Rename-Computer -NewName "BV-$SerialNumber" -Force
        Write-host "New PC Name is 'BV-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.113.*.*" )
    { 
        Rename-Computer -NewName "JM-$SerialNumber" -Force
        Write-host "New PC Name is 'JM-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.114.*.*" )
    { 
        Rename-Computer -NewName "RG-$SerialNumber" -Force
        Write-host "New PC Name is 'RG-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.115.*.*" )
    { 
        Rename-Computer -NewName "RJ-$SerialNumber" -Force
        Write-host "New PC Name is 'RJ-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.116.*.*" )
    { 
        Rename-Computer -NewName "ET-$SerialNumber" -Force
        Write-host "New PC Name is 'ET-$SerialNumber'" 
        Return 0

    }
    Elseif ($IPAddress -like "10.117.*.*" )
    { 
        Rename-Computer -NewName "OW-$SerialNumber" -Force
        Write-host "New PC Name is 'OW-$SerialNumber'" 
        Return 0

    }
    Elseif ($IPAddress -like "10.118.*.*" )
    { 
        Rename-Computer -NewName "LW-$SerialNumber" -Force
        Write-host "New PC Name is 'LW-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.119.*.*" )
    { 
        Rename-Computer -NewName "RPS3-$SerialNumber" -Force
        Write-host "New PC Name is 'RPS3-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.120.*.*" )
    { 
        Rename-Computer -NewName "BK-$SerialNumber" -Force
        Write-host "New PC Name is 'BK-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.121.*.*" )
    {   
        Rename-Computer -NewName "GH-$SerialNumber" -Force
        Write-host "New PC Name is 'GH-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.122.*.*" )
    { 
        Rename-Computer -NewName "NS-$SerialNumber" -Force
        Write-host "New PC Name is 'NS-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.123.*.*" )
    { 
        Rename-Computer -NewName "AD-$SerialNumber" -Force
        Write-host "New PC Name is 'WS-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.124.*.*" )
    { 
        Rename-Computer -NewName "PK-$SerialNumber" -Force
        Write-host "New PC Name is 'PK-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.125.*.*" )
    { 
        Rename-Computer -NewName "GF-$SerialNumber" -Force
        Write-host "New PC Name is 'GF-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.126.*.*" )
    { 
        Rename-Computer -NewName "JD-$SerialNumber" -Force
        Write-host "New PC Name is 'JD-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.127.*.*" )
    { 
        Rename-Computer -NewName "NT-$SerialNumber" -Force
        Write-host "New PC Name is 'NT-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.128.*.*" )
    { 
        Rename-Computer -NewName "CR-$SerialNumber" -Force
        Write-host "New PC Name is 'CR-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.129.*.*" )
    { 
        Rename-Computer -NewName "RPS2-$SerialNumber" -Force
        Write-host "New PC Name is 'RPS2-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.130.*.*" )
    { 
        Rename-Computer -NewName "FV-$SerialNumber" -Force
        Write-host "New PC Name is 'FV-$SerialNumber'"
        Return 0 
    }
    Elseif ($IPAddress -like "10.131.*.*" )
    { 
        Rename-Computer -NewName "REAP-$SerialNumber" -Force
        Write-host "New PC Name is 'REAP-$SerialNumber'" 
        Return 0
    }
    Elseif ($IPAddress -like "10.133.*.*" )
    { 
        Rename-Computer -NewName "WC-$SerialNumber" -Force
        Write-host "New PC Name is 'WC-$SerialNumber'" 
        Return 0
    }
    Else
    {
        Write-Host "Write-Host The IP address does not match any recorded subnets: $Ipaddress"
        Return 1603
    }

    # Remove the scheduled task
    Disable-ScheduledTask -TaskName "Rename-ComputerBasedOffIP" -ErrorAction Ignore
    Unregister-ScheduledTask -TaskName "Rename-ComputerBasedOffIP" -Confirm:$false -ErrorAction Ignore
    Write-Host "Scheduled task unregistered."

    # Make sure we reboot if still in ESP/OOBE by reporting a 1641 return code (hard reboot)
    if ($details.CsUserName -match "defaultUser")
    {
        Write-Host "Exiting during ESP/OOBE with return code 1641"
        Stop-Transcript
        Exit 1641
    }
    else {
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Exit 0
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
        Exit 1641
        Write-Warning "Computer is pending a reboot. Please do so and rerun script."
        Exit 1641
    } else {
        $false
        Precheck
    }
}
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber
$IPAddress = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select -Expand IPAddress | Where { $_ -like '*.*.*.*' })

$RenameDate = Get-Date -format yyyy-MM-ddTHH-mm
Start-Transcript 
CheckRebootStatus
Stop-Transcript
