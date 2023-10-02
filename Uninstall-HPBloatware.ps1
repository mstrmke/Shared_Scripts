(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security - Console'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security Application Support for Sure Sense'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Wolf Security Application Support for Chrome'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Notifications'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Security Update Service'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP System Default Settings'} -ComputerName . ).Uninstall()
(Get-WmiObject -Class Win32_Product -Filter {Name='ICS'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Sure Run Module'} -ComputerName . ).Uninstall() 
(Get-WmiObject -Class Win32_Product -Filter {Name='HP Documentation'} -ComputerName . ).Uninstall() 



#Removing Unneeded HP AppX Bundles
Get-AppxPackage -Name *myHP* | Remove-AppxPackage
Get-AppxPackage -Name *QuickDrop* | Remove-AppxPackage
Get-AppxPackage -Name *hpprivacysettings* | Remove-AppxPackage
Get-AppxPackage -Name *hpsysteminformation* | Remove-AppxPackage
Get-AppxPackage -Name *hpeasyclean* | Remove-AppxPackage