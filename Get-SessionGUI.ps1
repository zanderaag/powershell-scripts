function Get-SessionGUI (){
$sesh = Read-Host "Please enter a session name"
$comp = Read-Host "Please enter a computer name"
New-PSSession -ComputerName $comp -Name $sesh > null #suppress this cmdlet's output so it's not doubled up
Get-PSSession #display all sessions
}