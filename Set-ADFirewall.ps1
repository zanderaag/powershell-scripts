function Set-ADFirewall(){
Get-ADComputer -Filter * | Select -ExpandProperty Name | Out-File "C:\mysystems.txt"
    Invoke-Command -ComputerName (gc "C:\mysystems.txt") -ScriptBlock {
    $profiles = Get-NetFirewallProfile
            foreach ($fwprofile in $profiles){
                if ($fwprofile.Enabled -eq "False") {
                    Set-NetFirewallProfile -Name $fwprofile.Name -Enabled True
                    }
                }
    $status = Get-NetFirewallProfile | Where-Object {$_.Enabled -like "False"}
    if ($status) {
        Write-Host "$env:COMPUTERNAME"
        $status | Format-Table -property Name, Enabled   
        }  
    }
    Invoke-Command -ComputerName (gc "C:\mysystems.txt") -ScriptBlock {Get-NetFirewallApplicationFilter} | Out-File -Append C:\mysystems.txt
}


Set-ADFirewall