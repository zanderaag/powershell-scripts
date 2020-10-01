<#
.SYNOPSIS
    This script compares two folders against eachother for differences.
    Works for both OneDrive and local files.

.DESCRIPTION
    Using the $ReferenceFolder and $ComparisonFolder parameters this cmdlet will allow you to easily compare two folders and identify any differences between the two.

.PARAMETER ReferenceFolder
    The folder you wish to use as a reference point when comparing.  

.PARAMETER ComparisonFolder
    The folder you wish to compare to your reference folder.

.EXAMPLE
    Compare-Folders -ReferenceFolder '/Path/to/reference/folder/here' -ComparisonFolder '/Path/to/comparison/folder/here

#>
function Compare-Folders {

 Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $ReferenceFolder,
         [Parameter(Mandatory=$true, Position=1)]
         [string] $ComparisonFolder
         )


$co = (Compare-Object -ReferenceObject (Get-ChildItem -Recurse $ReferenceFolder) -DifferenceObject (Get-ChildItem -Recurse $ComparisonFolder)) | ForEach-Object {
    if ($_.SideIndicator -eq '=>') {
        $_.SideIndicator = "File not found in $ReferenceFolder"
        }
    elseif ($_.SideIndicator -eq '<=') {
        $_.SideIndicator = "File not found in $ComparisonFolder"
        }
        $_
        }

$co | ogv
}


