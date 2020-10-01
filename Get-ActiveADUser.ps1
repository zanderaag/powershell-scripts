function Get-ActiveADUser {

$name = Read-Host "Enter the name of the user to see if their account is active"
$a = Get-ADUser -Identity "$name" -properties * | Select-Object Enabled, lastlogontimestamp | format-list 
$a 
}

Get-ActiveADUser
