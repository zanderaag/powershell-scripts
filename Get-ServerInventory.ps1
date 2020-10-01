function Get-ServerInventory {


function Get-OnlineComputer {

$logfilepath = 'C:\Temp\offlinefile.log'

if (!([System.IO.File]::Exists($logfilepath))) {
New-Item -Path $logfilepath -ItemType File -Force
}
elseif ([System.IO.File]::Exists($logfilepath)) {
Write-Output $null | Out-File $logfilepath
}

$logfilepath2 = 'C:\Temp\onlinefile.log'

if (!([System.IO.File]::Exists($logfilepath2))) {
New-Item -Path $logfilepath2 -ItemType File -Force
}
elseif ([System.IO.File]::Exists($logfilepath2)) {
Write-Output $null | Out-File $logfilepath2
}

#ExpandProperty gives you the value inside the Name property but not the name header. Useful for iterating.
$array = @(Get-ADComputer -Filter * -Properties * | select -ExpandProperty Name)


foreach ($pc in $array) {

if (!(Test-Connection $pc -Count 1 -Quiet)) {
    Write-Output $pc | Out-File $logfilepath -Append -Force
    Write-Warning "$pc is not online."
}
elseif (Test-Connection $pc -Count 1 -Quiet) {
    Write-Output $pc | Out-File $logfilepath2 -Append -Force
    Write-Host "$pc is online and connected." -ForegroundColor Green
    }
  }
}
Get-OnlineComputer

function Get-HardwareInfo {
#Hard Drive Size
$hardDriveSize = (Get-CimInstance win32_logicaldisk -Filter "Caption='C:'" -Property *)


#Ram amount in Gigabytes
$ramAmount = (Get-CimInstance win32_physicalmemory -Property *)


#Get Operating System
$operatingSystem = (Get-CimInstance Win32_OperatingSystem -Property * | Select-Object -ExpandProperty Caption)

$ram2 = Write-Output ([Math]::Round($ramAmount.Capacity/1GB)) "GB"
$diskSize2 = Write-Output ([Math]::Round($hardDriveSize.Size/1MB)) "MB"
$freeSpace2 = Write-Output ([Math]::Round($hardDriveSize.FreeSpace/1MB)) "MB"

$hashes = New-Object PSObject -Property @{
        DiskSize = "$diskSize2"
        FreeSpace = "$freeSpace2"
        RAM = "$ram2"
        OperatingSystem ="$operatingSystem"
        }
        $hashes 
         
         
}


function Run-ServerInventoryRemote {
$f = Invoke-Command -ComputerName @(Get-Content 'C:\Temp\onlinefile.log') -ScriptBlock ${Function:Get-HardwareInfo} -ErrorAction SilentlyContinue
$f

}
Run-ServerInventoryRemote | Select-Object -Property OperatingSystem, FreeSpace, DiskSize, RAM, PSComputerName #| format-Table -AutoSize -Property OperatingSystem, ComputerName, FreeSpace, DiskSize, RAM
}
#Basic CSS styling for the report.
$Header = @"
<style>
table {
font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
border-collapse: collapse;
width: 100%;
}
th {
padding-top: 12px;
padding-bottom: 12px;
text-align: left;
background-color: #4CAF50;
color: white;
}
</style>
"@

$d = Get-ServerInventory 
$e = $d | ConvertTo-Html
ConvertTo-Html -Body $e -Title "Report" -Head $Header | Out-File C:\Temp\serverinventory.html -Force


$l = @(Get-Content C:\Temp\offlinefile.log)
$newarr = @()
foreach ($i in $l) {
$offline = Write-Output "$i is Offline."
ConvertTo-Html -Body $offline -Title "Report" -Head $Header | Out-File -Append C:\Temp\serverinventory.html -Force
}
Invoke-Item C:\Temp\serverinventory.html