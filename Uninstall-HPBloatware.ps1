(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security - Console'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security Application Support for Sure Sense'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Notifications'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Security Update Service'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP System Default Settings'} -ComputerName . ).Uninstall() 

$HPBloatware = Test-Path -Path "C:\Program Files (x86)\HP\HP Support Framework\UninstallHPSA.exe" 
if ($HPBloatware -eq $True)
{
start-process -FilePath "C:\Program Files (x86)\HP\HP Support Framework\UninstallHPSA.exe" -ArgumentList "/s /v /qn"
Return $LASTEXITCODE
}
Else { Write-Host "HP Support Assistant already uninstalled"; Return 0}
