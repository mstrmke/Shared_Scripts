
<#	
  .NOTES
  ===========================================================================
   Created on:   	05/12/2023
   Created by:   	Ryan Hogan
   Organization: 	Heartland Business Systems
   Filename:     	Rename-ComputerBasedOffIP.ps1
   Version:         1.0 (Initial Version)
                    1.1 Removed Scheduled Task and putting tagged file in new "mem" folder. 
                    1.2 - moved Restart Command in each subnet
                    1.3 - Added check in each subnet if the computer already had the needed Prefix, to skip renaming.
                    1.4 - Removed grebbing serial number and we are now grabbing Asset Tag.
  ===========================================================================
  
  .DESCRIPTION
    This script uses a WMI object call to get the IP address and rename a computer to the requested Prefix followed by the machines Serial Number. 
 

#>

Param()
Function Precheck
{

# Create a tag file just so Intune knows this was installed
$dest = "$env:ProgramData\mem\Rename-ComputerBasedOffIP"
if (-not (Test-Path $dest))
{
    mkdir $dest
    Set-Content -Path "$env:ProgramData\mem\Rename-ComputerBasedOffIP\Rename-ComputerBasedOffIP.ps1.tag" -Value "Renamed"
}
Start-Transcript -Path "$env:ProgramData\mem\Rename-ComputerBasedOffIP\Rename-ComputerBasedOffIP_$RenameDate.log" -Append

# Make sure we are already domain-joined
$details = Get-ComputerInfo

if (-not $details.CsPartOfDomain)
{
    Write-Host "Not part of a domain."
    Exit 1404 # Add this Return Code ce number in InTune program setup.
}

# Make sure we have connectivity
if (!(Test-ComputerSecureChannel)) {

    Write-Host "No connectivity to the domain."
    Exit 1405 # Add this Return Code number in InTune program setup.
}

If (!($AssetTagNumber)){
    Write-Host "No Asset Tag Found, exiting script."
    Exit 1406 # Add this Return Code number in InTune program setup.
}

goodToGo
}

Function goodToGo
{
    # Make sure we reboot if still in ESP/OOBE by reporting a 1641 return code (hard reboot)
    if ($LoggedOnUser -match "defaultUser")
    {
        Write-Host "Exiting during ESP/OOBE with return code 1641"
        Stop-Transcript
        Exit 1641
    }
    #WMI Command to exclude if a laptop Azure AD grooup "RSD Laptops"
    ElseIf ($details.CsPCSystemType -eq "Mobile")
    {
        Write-Host "This is a laptop, I will generate the LT-$AssetTagNumber PC Name."
        Try {
            Rename-Computer -NewName "LT-$AssetTagNumber" -Force
            Write-host "New PC Name is 'LT-$AssetTagNumber'" 
            Return 0
            Restart-Computer
            
        }
        Catch {Exit 1603}
    }

    <# Removing ADMIN for imaging Process.
    ElseIf (-not $details.CsName.StartsWith("AD") -and $IPAddress -like "10.102.*.*" )
    { 
        Rename-Computer -NewName "AD-$AssetTagNumber" -Force
        Write-host "New PC Name is 'AD-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    #>
    Elseif (-not $details.CsName.StartsWith("RHS") -and $IPAddress -like "10.103.*.*" )
    { 
        Rename-Computer -NewName "RHS-$AssetTagNumber" -Force
        Write-host "New PC Name is 'RHS-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("HHS") -and $IPAddress -like "10.104.*.*" )
    {    
        Rename-Computer -NewName "HHS-$AssetTagNumber" -Force
        Write-host "New PC Name is 'HHS-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
<#    Removing TECH for imaging Process. 
        Elseif (-not $details.CsName.StartsWith("TECH") -and $IPAddress -like "10.105.*.*" )
    { 
        Rename-Computer -NewName "TECH-$AssetTagNumber" -Force
        Write-host "New PC Name is 'TECH-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
#>
    Elseif (-not $details.CsName.StartsWith("EW") -and $IPAddress -like "10.106.*.*" )
    { 
        Rename-Computer -NewName "EW-$AssetTagNumber" -Force
        Write-host "New PC Name is 'EW-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("GL") -and $IPAddress -like "10.107.*.*" )
    { 
        Rename-Computer -NewName "GL-$AssetTagNumber" -Force
        Write-host "New PC Name is 'GL-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("OD") -and $IPAddress -like "10.108.*.*" )
    { 
        Rename-Computer -NewName "OD-$AssetTagNumber" -Force
        Write-host "New PC Name is 'OD-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("FT") -and $IPAddress -like "10.109.*.*" )
    { 
        Rename-Computer -NewName "FT-$AssetTagNumber" -Force
        Write-host "New PC Name is 'FT-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("BG") -and $IPAddress -like "10.110.*.*" )
    { 
        Rename-Computer -NewName "BG-$AssetTagNumber" -Force
        Write-host "New PC Name is 'BG-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("ES") -and $IPAddress -like "10.111.*.*" )
    { 
        Rename-Computer -NewName "ES-$AssetTagNumber" -Force
        Write-host "New PC Name is 'ES-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("BV") -and $IPAddress -like "10.112.*.*" )
    { 
        Rename-Computer -NewName "BV-$AssetTagNumber" -Force
        Write-host "New PC Name is 'BV-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("JM") -and $IPAddress -like "10.113.*.*" )
    { 
        Rename-Computer -NewName "JM-$AssetTagNumber" -Force
        Write-host "New PC Name is 'JM-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("RG") -and $IPAddress -like "10.114.*.*" )
    { 
        Rename-Computer -NewName "RG-$AssetTagNumber" -Force
        Write-host "New PC Name is 'RG-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("RJ") -and $IPAddress -like "10.115.*.*" )
    { 
        Rename-Computer -NewName "RJ-$AssetTagNumber" -Force
        Write-host "New PC Name is 'RJ-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("ET") -and $IPAddress -like "10.116.*.*" )
    { 
        Rename-Computer -NewName "ET-$AssetTagNumber" -Force
        Write-host "New PC Name is 'ET-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0

    }
    Elseif (-not $details.CsName.StartsWith("OW") -and $IPAddress -like "10.117.*.*" )
    { 
        Rename-Computer -NewName "OW-$AssetTagNumber" -Force
        Write-host "New PC Name is 'OW-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0

    }
    Elseif (-not $details.CsName.StartsWith("LW") -and $IPAddress -like "10.118.*.*" )
    { 
        Rename-Computer -NewName "LW-$AssetTagNumber" -Force
        Write-host "New PC Name is 'LW-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("RPS3") -and $IPAddress -like "10.119.*.*" )
    { 
        Rename-Computer -NewName "RPS3-$AssetTagNumber" -Force
        Write-host "New PC Name is 'RPS3-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("BK") -and $IPAddress -like "10.120.*.*" )
    { 
        Rename-Computer -NewName "BK-$AssetTagNumber" -Force
        Write-host "New PC Name is 'BK-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("GH") -and $IPAddress -like "10.121.*.*" )
    {   
        Rename-Computer -NewName "GH-$AssetTagNumber" -Force
        Write-host "New PC Name is 'GH-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("NS") -and $IPAddress -like "10.122.*.*" )
    { 
        Rename-Computer -NewName "NS-$AssetTagNumber" -Force
        Write-host "New PC Name is 'NS-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("WS") -and $IPAddress -like "10.123.*.*" )
    { 
        Rename-Computer -NewName "WS-$AssetTagNumber" -Force
        Write-host "New PC Name is 'WS-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("PK") -and $IPAddress -like "10.124.*.*" )
    { 
        Rename-Computer -NewName "PK-$AssetTagNumber" -Force
        Write-host "New PC Name is 'PK-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("GF") -and $IPAddress -like "10.125.*.*" )
    { 
        Rename-Computer -NewName "GF-$AssetTagNumber" -Force
        Write-host "New PC Name is 'GF-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("JD") -and $IPAddress -like "10.126.*.*" )
    { 
        Rename-Computer -NewName "JD-$AssetTagNumber" -Force
        Write-host "New PC Name is 'JD-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("NT") -and $IPAddress -like "10.127.*.*" )
    { 
        Rename-Computer -NewName "NT-$AssetTagNumber" -Force
        Write-host "New PC Name is 'NT-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("CR") -and $IPAddress -like "10.128.*.*" )
    { 
        Rename-Computer -NewName "CR-$AssetTagNumber" -Force
        Write-host "New PC Name is 'CR-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("RPS2") -and $IPAddress -like "10.129.*.*" )
    { 
        Rename-Computer -NewName "RPS2-$AssetTagNumber" -Force
        Write-host "New PC Name is 'RPS2-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Elseif (-not $details.CsName.StartsWith("FV") -and $IPAddress -like "10.130.*.*" )
    { 
        Rename-Computer -NewName "FV-$AssetTagNumber" -Force
        Write-host "New PC Name is 'FV-$AssetTagNumber'"
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0 
    }
<# Removing REAP for imaging Process.
    Elseif (-not $details.CsName.StartsWith("REAP") -and $IPAddress -like "10.131.*.*" )
    { 
        Rename-Computer -NewName "REAP-$AssetTagNumber" -Force
        Write-host "New PC Name is 'REAP-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
#>
    Elseif (-not $details.CsName.StartsWith("WC") -and $IPAddress -like "10.133.*.*" )
    { 
        Rename-Computer -NewName "WC-$AssetTagNumber" -Force
        Write-host "New PC Name is 'WC-$AssetTagNumber'" 
        Write-Host "Initiating a restart in 10 minutes"
        & shutdown.exe /g /t 600 /f /c "Restarting the computer due to a computer name change.  Please save your work."
        Stop-Transcript
        Return 0
    }
    Else
    {
        Write-Host "Write-Host The IP address does not match any recorded subnets: $Ipaddress"
        Remove-Item -Path "$env:ProgramData\mem\Rename-ComputerBasedOffIP\Rename-ComputerBasedOffIP.ps1.tag" -Force -Confirm:$false
        Return 1603
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
$AssetTagNumber = (Get-WmiObject -class win32_systemenclosure).SMBIOSAssetTag
$IPAddress = (Get-WmiObject Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select -Expand IPAddress | Where { $_ -like '*.*.*.*' })
$LoggedOnUser=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$RenameDate = Get-Date -format yyyy-MM-ddTHH-mm
Start-Transcript 
CheckRebootStatus