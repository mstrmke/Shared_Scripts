Install-Module -Name PowerShellGet -Repository PSGallery -Force -AllowClobber
Install-Module -Name Az.Maintenance -Force
Import-Module -Name Az.Maintenance
$SecurePassword = ConvertTo-SecureString -String "Zsi8Q~AyQeg48x2u98x2VPSYFX4DkXTmH7O.9aa0" -AsPlainText -Force
$TenantId = 'f41f4d49-5547-4a14-a471-d573bb8ad4f3'
$ApplicationId = 'b1a125ad-c94d-4588-bee2-2fed047017f7'
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecurePassword
Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential
$SUMonth=Get-Date -Format "MM-yyyy"
$RGName = "RG-AzureUpdateManager-Prod-01"
$configName = "Prod-Server-Group-Noboot"
$scope = "InGuestPatch"
$location = "northcentralus"
$timeZone = "Central Standard Time"
$duration = "03:00"
$startDateTime = Get-Date -Format "yyyy-MM-dd 19:00"(Get-date).AddDays(3)
$WindowsParameterClassificationToInclude ="Critical updates","Security updates","Update rollups","Definition updates";
$RebootOption = "Never";
$LinuxParameterClassificationToInclude = "Other";
$LinuxParameterPackageNameMaskToInclude = "apt","httpd";
$LinuxParameterPackageNameMaskToExclude = "ppt","userpk";

New-AzMaintenanceConfiguration
   -ResourceGroup $RGName `
   -Name $configName_$SUMonth `
   -MaintenanceScope $scope `
   -Location $location `
   -StartDateTime $startDateTime `
   -TimeZone $timeZone `
   -Duration $duration `
   -WindowParameterClassificationToInclude $WindowsParameterClassificationToInclude `
   -InstallPatchRebootSetting $RebootOption `
   -LinuxParameterPackageNameMaskToInclude $LinuxParameterPackageNameMaskToInclude `
   -LinuxParameterClassificationToInclude $LinuxParameterClassificationToInclude `
   -LinuxParameterPackageNameMaskToExclude $LinuxParameterPackageNameMaskToExclude `
   -ExtensionProperty @{"InGuestPatchMode"="User"}