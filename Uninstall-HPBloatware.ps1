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
Remove-AppxPackage AD2F1837.myHP_25.52330.450.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpeasyclean_2.2.5.0_neutral_split.scale-150_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpeasyclean_2.2.5.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpeasyclean_2023.424.454.0_neutral_~_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hppchardwarediagnosticswindows_2.3.2.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hppowermanager_2023.119.1142.0_neutral_~_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hppowermanager_3.1.3.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpprivacysettings_1.3.7.0_neutral_split.scale-150_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpprivacysettings_1.3.7.0_neutral_~_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpprivacysettings_1.3.7.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpsysteminformation_2023.227.1120.0_neutral_~_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.hpsysteminformation_8.10.39.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.myhp_25.52334.606.0_neutral_split.scale-150_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.myhp_25.52334.606.0_neutral_~_v10z8vjag6ke6 -ErrorAction SilentlyContinue
Remove-AppxPackage ad2f1837.myhp_25.52334.606.0_x64__v10z8vjag6ke6 -ErrorAction SilentlyContinue