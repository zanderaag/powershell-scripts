##Grabs a pre-determined list of attributes from the provided .txt/.csv file and displays them/set the attributes in AD and display results through OGV.
##This script can be modified to do just about any basic data fetching from AD provided the appropriate data is provided.

function Fetch-ADUserData {
$readfile = Read-Host 'Please enter the absolute path of the .CSV containing your SAMAccountNames/UPNs.'
$csvimport = Import-Csv $readfile
foreach ($name in $csvimport) {
    
    Get-ADUser -Identity $name.UPN -Properties * | Select-Object Name,Company,Department
    }
}
Fetch-ADUserData | ogv
