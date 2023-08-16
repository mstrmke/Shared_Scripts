$WCSBW = Get-Printer -Name "\\WSDPS1\WDS-BW"
$WCSCOLOR = Get-Printer -Name "\\WSDPS1\WDS-COLOR"

If (-not $WCSBW){
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\WSDPS1\WCS-BW")
    Write-Host "B/W Printer Installed!"
}
Else { Write-Host "No Printer added, B/W Printer was already installed." }
    
If (-not $WCSCOLOR){
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\WSDPS1\WCS-COLOR")
    Write-Host "Color Printer Installed!"
}
Else { Write-Host "No Printer addedk, Color Printer was already installed." }