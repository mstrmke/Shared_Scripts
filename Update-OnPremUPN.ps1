#Specify UPN Domain
$Domain = 'NewDOMAINUPN.com'
 
#Get list of samaccountnames in our targeted OU
$UserList = Get-ADUser -Filter * -SearchBase 'OU=Excluded,DC=ad,DC=thesysadminchannel,DC=com' | `
select -ExpandProperty SamAccountName
 
#Change UPN Suffix from sub domain to primary domain
foreach ($User in $UserList) {
    Get-ADUser $User | Set-ADUser -UserPrincipalName "$User@$Domain"
}
 
Get-ADUser -Filter * -SearchBase 'OU=Excluded,DC=ad,DC=thesysadminchannel,DC=com' | select Name, UserPrincipalName