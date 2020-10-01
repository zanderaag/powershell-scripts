function Run-ConfigMgrActions {

 Param
    (
         [Parameter(Mandatory=$false)]
         [string] $ComputerName
         )

$prefixes = @('OME','W10','W7')
$regex = '^(' + (($prefixes | ForEach-Object { 
[regex]::Escape($_) + '[a-zA-Z0-9_-]{1,' + (15 - $_.Length) + '}' }) -join '|') + ')'



#Test to ensure the user is typing in a valid NetBIOS name.
if ($ComputerName -match $regex) {
    Write-Warning "This is a valid computer name. Continuing."
    }
elseif ($ComputerName -eq $null -or $ComputerName -eq '') {
$ComputerName = HOSTNAME.EXE
}
else {
break
}

$GroupPolicyFolder = Test-Path C:\Windows\System32\GroupPolicy -OlderThan (Get-Date).AddDays(-31)
if ($GroupPolicyFolder) {
Write-Host "Group policy folder is older than a month. Deleting folder and re-creating with gpupdate."
Remove-Item C:\Windows\System32\GroupPolicy -Recurse -Force
cmd.exe /c gpupdate /force
}
else {
Write-Host "Group policy is up to date."
}

#Application Deployment Evaluation Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000121}" 
#Discovery Data Collection Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000003}" 
#File Collection Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000010}" 
#Hardware Inventory Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000001}" 
#Machine Policy Retrieval Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000021}" 
#Machine Policy Evaluation Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000022}" 
#Software Inventory Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000002}" 
#Software Metering Usage Report Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000031}" 
#Software Update Deployment Evaluation Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000114}" 
#Software Update Scan Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000113}" 
#State Message Refresh 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000111}" 
#Windows Installers Source List Update Cycle 
Invoke-WMIMethod -ComputerName $ComputerName -Namespace root\ccm -Class SMS_CLIENT -Name TriggerSchedule "{00000000-0000-0000-0000-000000000032}" 

}

