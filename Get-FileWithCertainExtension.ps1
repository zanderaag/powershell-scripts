function Get-FileWithCertainExtension {

$array = @(Get-ADComputer -Filter * -Properties * | select -ExpandProperty Name)

Invoke-Command -ComputerName ($array) -ScriptBlock {

#Check if the C:\Temp\Pictures folder exists. If not, create it.
if (!(Test-Path C:\Temp\Pictures)) {

New-Item -Path C:\Temp\Pictures -ItemType Directory -Force
Write-Output (Write-Host "`nThe C:\Temp\Pictures now exists on $(hostname.exe)" -ForegroundColor Green)
}

#Get a list of all the files with X filetype on the system recursively.
$filearray = @(Get-ChildItem -Path C:\ -Recurse -Filter *.jpg)

#Copy all files with X filetype recursively to the C:\Temp\Pictures folder.
$count = 0
foreach ($file in $filearray) {

$name = $file.Name
if (!(Test-Path C:\Temp\Pictures\$name)) {
Copy-Item "$($file.DirectoryName + "\" + $file.Name)" -Destination C:\Temp\Pictures
Write-Output (Write-Host "$($file.Name) has been successfully copied into C:\Temp\Pictures on $(hostname.exe)" -ForegroundColor Green)
$count++
}
}
sleep 2
Write-Output (Write-Host "`n$count files were copied over to C:\Temp\Pictures on $(hostname.exe)" -ForegroundColor DarkYellow)

}

}
Get-FileWithCertainExtension