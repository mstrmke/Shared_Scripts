(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security - Console'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security Application Support for Sure Sense'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Notifications'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Security Update Service'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP System Default Settings'} -ComputerName . ).Uninstall() 

$HPSupportAssistant = Test-Path -Path "C:\Program Files (x86)\HP\HP Support Framework\UninstallHPSA.exe" 
if ($HPSupportAssistant -eq $True)
{
start-process -FilePath "C:\Program Files (x86)\HP\HP Support Framework\UninstallHPSA.exe" -ArgumentList "/s /v /qn"
Return $LASTEXITCODE
}
Else { Write-Host "HP Support Assistant already uninstalled"; Return 0}


#Removing HP AppX Bundles
Remove-AppxPackage AD2F1837.myHP_25.52330.450.0_x64__v10z8vjag6ke6 #MyHP