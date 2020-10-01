function Set-PSRestrictedUsers {

$newuser = Read-Host "Enter the name of the new user"

New-ADUser -Name "$newuser" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -DisplayName "$newuser" -Enabled $true

$newgroup = Read-Host "Enter the name of the new group"

New-ADGroup -Name $newgroup -GroupCategory Security -GroupScope Global -Description "Group with a name of $newgroup"

Add-ADGroupMember -Identity $newgroup -Members $newuser

Add-ADGroupMember -Identity $newgro
up -Members Administrator

Get-ADGroupMember -Identity $newgroup | Select-Object distinguishedName, name, objectClass, objectGUID, SamAccountName | ft


}
Set-PSRestrictedUsers
