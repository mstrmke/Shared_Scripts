<#  
    Author : Ryan Hogan
    Produces GPO inventory report
    version 1.2 | 01/09/2021 Initial version

    Disclaimer: This script is designed to only read data from the domain and should not cause any problems or change configurations but author do not claim to be responsible for any issues. Do due dilligence before running in the production environment

#>

Import-Module ActiveDirectory
Import-Module GroupPolicy

# Output formating options
$logopath = ""
$ReportPath = "$env:USERPROFILE\desktop\ADReport_$(get-date -Uformat "%Y%m%d-%H%M%S").html"
#$CopyRightInfo = " @Copyright Nitish Kumar <a href='https://github.com/laymanstake'>Visit nitishkumar.net</a>"
$CopyRightInfo = ""
$logpath = "$env:USERPROFILE\desktop\ADReport_$(get-date -Uformat "%Y%m%d-%H%M%S").txt"

# CSS codes to format the report
$header = @"
<style>
    body { background-color: #b9d7f7; }
    h1 { font-family: Arial, Helvetica, sans-serif; color: #e68a00; font-size: 28px; }    
    h2 { font-family: Arial, Helvetica, sans-serif; color: #000099; font-size: 16px; }    
    table { font-size: 12px; border: 1px;  font-family: Arial, Helvetica, sans-serif; } 	
    td { padding: 4px; margin: 0px; border: 1; }	
    th { background: #395870; background: linear-gradient(#49708f, #293f50); color: #fff; font-size: 11px; text-transform: uppercase; padding: 10px 15px; vertical-align: middle; }
    tbody tr:nth-child(even) { background: #f0f0f2; }
    CreationDate { font-family: Arial, Helvetica, sans-serif; color: #ff3300; font-size: 12px; }
</style>
"@

If ($logopath) {
    $header = $header + "<img src=$logopath alt='Company logo' width='150' height='150' align='right'>"
}

# This function creates log entries for the major steps in the script.
function Write-Log {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true, mandatory = $true)]$logtext,
        [Parameter(ValueFromPipeline = $true, mandatory = $true)]$logpath
    )

    $Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
    $LogMessage = "$Stamp : $logtext"
    
    $isWritten = $false

    do {
        try {
            Add-content $logpath -value $LogMessage -Force -ErrorAction SilentlyContinue
            $isWritten = $true
        }
        catch {
        }
    } until ( $isWritten )
}

# This function creates a balloon notification to display on client computers.
function New-BaloonNotification {
    Param(
        [Parameter(ValueFromPipeline = $true, mandatory = $true)][String]$title,
        [Parameter(ValueFromPipeline = $true, mandatory = $true)][String]$message,        
        [Parameter(ValueFromPipeline = $true, mandatory = $false)][ValidateSet('None', 'Info', 'Warning', 'Error')][String]$icon = "Info",
        [Parameter(ValueFromPipeline = $true, mandatory = $false)][scriptblock]$Script
    )
    Add-Type -AssemblyName System.Windows.Forms

    if ($null -eq $script:balloonToolTip) { $script:balloonToolTip = New-Object System.Windows.Forms.NotifyIcon }

    $tip = New-Object System.Windows.Forms.NotifyIcon


    $path = Get-Process -id $pid | Select-Object -ExpandProperty Path
    $tip.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    $tip.BalloonTipIcon = $Icon
    $tip.BalloonTipText = $message
    $tip.BalloonTipTitle = $title    
    $tip.Visible = $true            
    
    try {
        register-objectevent $tip BalloonTipClicked BalloonClicked_event -Action { $script.Invoke() } | Out-Null
    }
    catch {}
    $tip.ShowBalloonTip(10000) # Even if we set it for 1000 milliseconds, it usually follows OS minimum 10 seconds
    Start-Sleep -seconds 1
    
    $tip.Dispose() # Important to dispose otherwise the icon stays in notifications till reboot
    Get-EventSubscriber -SourceIdentifier "BalloonClicked_event"  -ErrorAction SilentlyContinue | Unregister-Event # In case if the Event Subscription is not disposed
}

# This function summarizes Group Policy Objects (GPOs) in the Active Directory domain, including linked locations, and scope.
Function Get-ADGPOSummary {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true, mandatory = $true)]$DomainName        
    )
    
    $PDC = (Test-Connection -Computername (Get-ADDomainController -Filter *  -Server $DomainName ).Hostname -count 1 -AsJob | Get-Job | Receive-Job -Wait | Where-Object { $null -ne $_.Responsetime } | sort-object Responsetime | select-Object Address -first 1).Address
    $null = Get-Job | Remove-Job -force

    $AllGPOs = Get-GPO -All -Domain $DomainName -Server $PDC

    $ROOTGPOS = (Get-ADDomain -Server $DomainName ).LinkedGroupPolicyObjects | ForEach-Object { [regex]::Match($_, '{.*?}').Value.Trim('{}') }
    $OUGPOS = Get-ADOrganizationalUnit -LDAPFilter '(GPLink=*)' -server $PDC  -Properties GPLink | Select-Object -ExpandProperty LinkedGroupPolicyObjects | ForEach-Object { ($_ -split ',')[0].Substring(3).Trim('{}') } | Select-Object -Unique

    $GPOsAtRootLevel = ($ROOTGPOS | ForEach-object { Get-GPO -Guid $_ -Domain $DomainName -Server $PDC }).Displayname
    
    $LinkedGPOs = ($OUGPOS + $ROOTGPOS) | select-Object -unique | ForEach-object { Get-GPO -guid $_ -Domain $DomainName -Server $PDC } | Select-Object DisplayName, CreationTime, ModificationTime
    $UnlinkedGPOs = @($AllGPOs | Where-Object { $_.DisplayName -NotIn $LinkedGPOs.DisplayName } | Select-Object DisplayName, CreationTime, ModificationTime )
    $DeactivatedGPOs = @($AllGPOs | Where-Object { $_.GPOStatus -eq "AllSettingsDisabled" } | Select-Object DisplayName, CreationTime, ModificationTime )
    
    $LinkedButDeactivatedGPOs = @()

    If ($LinkedGPOs.count -ge 1 -AND $DeactivatedGPOs.Count -ge 1) {
        $LinkedButDeactivatedGPOs = (Compare-Object -ReferenceObject $DeactivatedGPOs -DifferenceObject $LinkedGPOs -IncludeEqual | Where-Object { $_.SideIndicator -eq '==' } | Select-Object InputObject).InputObject
    }    

    $UnlinkedGPODetails = [PSCustomObject]@{
        Domain                      = $domainname
        AllGPOs                     = $AllGPOs.count
        GPOsAtRoot                  = $GPOsAtRootLevel -join "`n"
        Unlinked                    = @($UnlinkedGPOs).DisplayName -join "`n"
        UnlinkedCreationTime        = @($UnlinkedGPOs).CreationTime -join "`n"
        UnlinkedModificationTime    = @($UnlinkedGPOs).ModificationTime -join "`n"
        UnlinkedCount               = @($UnlinkedGPOs).count
        Deactivated                 = @($DeactivatedGPOs).DisplayName -join "`n"
        DeactivatedCreationTime     = @($DeactivatedGPOs).CreationTime -join "`n"
        DeactivatedModificationTime = @($DeactivatedGPOs).ModificationTime -join "`n"
        DeactivatedCount            = @($DeactivatedGPOs).count
        LinkedButDeactivated        = @($LinkedButDeactivatedGPOs).DisplayName -join "`n"
        LinkedButDeactivatedCount   = @($LinkedButDeactivatedGPOs).Count
    }
    
    return $UnlinkedGPODetails
}

# This function provides an inventory of GPOs in the Active Directory domain, including their names, scope, wmi filters and applied locations.
Function Get-GPOInventory {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true, mandatory = $true)]$DomainName     
    )
    
    $GPOSummary = @()
    $PDC = (Test-Connection -Computername (Get-ADDomainController -Filter * -Server $DomainName).Hostname -count 1 -AsJob | Get-Job | Receive-Job -Wait | Where-Object { $null -ne $_.Responsetime } | sort-object Responsetime | select-Object Address -first 1).Address
    $null = Get-Job | Remove-Job


    $ADDomain = Get-ADDomain -Identity $DomainName
    $DNComponents = $ADDomain.DistinguishedName.Split(',')
    $PoliciesContainer = "CN=Policies"
    $SystemContainer = "CN=System"
    $SearchBase = "$PoliciesContainer,$SystemContainer"

    foreach ($component in $DNComponents) {
        $SearchBase += ",$component"
    }

    $GPOs = Get-GPO -All -Domain $DomainName -Server $PDC
    $ROOTGPOS = (Get-ADDomain -Server $DomainName ).LinkedGroupPolicyObjects | ForEach-Object { [regex]::Match($_, '{.*?}').Value.Trim('{}') }

    $LinkedGPOs = foreach ($GPO in $GPOs) {
        $GPOLinks = Get-ADOrganizationalUnit -Filter "gpLink -like '*$($GPO.Id.ToString('B'))*'" -server $PDC | Select-Object -ExpandProperty DistinguishedName
        $GPO | Select-Object DisplayName, @{Name = 'Links'; Expression = { $GPOLinks } }
    }
    
    $GPOs | ForEach-Object {
        $GPO = $_        
        $Permissions = Get-GPPermission -Name $_.DisplayName -All -DomainName $DomainName -server $PDC | Select-Object @{l = "Permission"; e = { "$($_.Trustee.Name), $($_.Trustee.SIDType), $($_.permission), Denied: $($_.Denied)" } }, @{l = "GPOApply"; e = { "$(($_ | Where-Object { $_.permission -eq "GpoApply" }).Trustee.Name)" } }
        $Links = ($LinkedGPOs | Where-Object { $_.DisplayName -eq $GPO.DisplayName }).Links

        if ($GPO.ID -in $RootGPOs) {
            $Links += $ADDomain.DistinguishedName
        }

        try {
            $wmifilterid = ($_.WmiFilter.Path -split '"')[1]
            $wmiquery = ((Get-ADObject -Filter { objectClass -eq 'msWMI-Som' } -Server $PDC -Properties 'msWMI-Parm2' | where-object { $_.name -eq $wmifilterid })."msWMI-Parm2" -split "root\\CIMv2;")[1]    
        }
        catch {
            Write-Log -logtext "Erorr in getting WmiFilter $_.WmiFilter.Name query : $($_.Exception.Message)" -logpath $logpath
        }
        
        Foreach ($link in $links) {
            $GPOSummary += [pscustomobject]@{
                Domain           = $DomainName
                GPOName          = $_.DisplayName
                Creationtime     = $_.CreationTime
                ModificationTime = $_.ModificationTime
                Link             = $Link
                ComputerSettings = $_.Computer.Enabled
                UserSettings     = $_.User.Enabled
                GPOApply         = $Permissions.GPOApply -join "`n"
                Permissions      = $Permissions.Permission -join "`n"
                WmiFilter        = $_.WmiFilter.Name
                WmiQuery         = $wmiquery
            
            }
        }
    }

    return $GPOSummary
}

$GPOSummaryDetails = @()
$GPODetails = @()

$ForestInfo = Get-ADForest -Current LocalComputer 
$allDomains = $ForestInfo.Domains


ForEach ($domain in $allDomains) {
    $GPOSummaryDetails += Get-ADGPOSummary -DomainName $domain

    $message = "Working over domain: $Domain GPO ($(($GPOSummaryDetails | Where-Object {$_.Domain -eq $domain}).AllGPOs)) related details."
    New-BaloonNotification -title "Information" -message $message
    Write-Log -logtext $message -logpath $logpath

    $GPODetails += Get-GPOInventory -DomainName $domain

    $message = "GPO related details from domain: $Domain done."
    New-BaloonNotification -title "Information" -message $message
    Write-Log -logtext $message -logpath $logpath
}

$GPOSummary = ($GPOSummaryDetails | ConvertTo-Html -As Table  -Fragment -PreContent "<h2>GPO Summary</h2>") -replace "`n", "<br>"
$GPOInventory = ($GPODetails | ConvertTo-Html -As Table  -Fragment -PreContent "<h2>GPO Inventory</h2>") -replace "`n", "<br>"

$GPOSummaryDetails | export-csv -nti $env:USERPROFILE\desktop\GPOSummaryDetails.csv
$GPODetails | export-csv -nti $env:USERPROFILE\desktop\GPODetails.csv

$message = "GPO details collected now, preparing html report"
New-BaloonNotification -title "Information" -message $message
Write-Log -logtext $message -logpath $logpath

$ReportRaw = ConvertTo-HTML -Body "$GPOSummary $GPOInventory" -Head $header -Title "GPO Report" -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date) $CopyRightInfo </p>"
$ReportRaw | Out-File $ReportPath
