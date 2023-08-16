$WCSBW = Get-Printer -Name "\\WSDPS1\WDS-BW"
$WCSCOLOR = Get-Printer -Name "\\WSDPS1\WDS-COLOR"

If ($WCSBW){
    Write-Host "B/W Printer was already installed."
    Exit 0
}
Else {
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\WSDPS1\WCS-BW")
    Write-Host "B/W Printer Installed!"
    Exit 0
}

If ($WCSCOLOR){
    Write-Host "Color Printer was already installed."
    Exit 0
}
Else {
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\WSDPS1\WCS-COLOR")
    Write-Host "Color Printer Installed!"
    Exit 0
}