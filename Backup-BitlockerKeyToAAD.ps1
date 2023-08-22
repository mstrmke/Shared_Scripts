$BLV = Get-BitLockerVolume -MountPoint "$env:SystemDrive"

Try{
BackupToAAD-BitLockerKeyProtector -MountPoint $env:SystemDrive -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
Exit 0
}
Catch { Write-Host "Error uploading key to Azure AD: $_.Exception.Message"
Exit $LASTEXITCODE 
}