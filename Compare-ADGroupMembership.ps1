<#
.SYNOPSIS
    This script compares two AD groups against eachother for differences.
 
.DESCRIPTION
    Using the $ReferenceUser and $ComparisonUser parameters this cmdlet will allow you to easily compare two users and identify any differences between the two.

.PARAMETER ReferenceUser
    The user you wish to use as a reference point when comparing.  

.PARAMETER ComparisonUser
    The user you wish to compare to your reference user.

.EXAMPLE
    Compare-ADGroupMembership -ReferenceUser (Get-ADPrincipalGroupMembership User1) -ComparisonUser (Get-ADPrincipalGroupMembership User2)

#>
function Compare-ADGroupMembership {

 Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $ReferenceUser,
         [Parameter(Mandatory=$true, Position=1)]
         [string] $ComparisonUser
         )


$co = (Compare-Object -ReferenceObject (Get-AdPrincipalGroupMembership $ReferenceUser | select name | sort-object -Property name) -DifferenceObject (Get-AdPrincipalGroupMembership $ComparisonUser | select name | sort-object -Property name) -Property name -PassThru) | ForEach-Object {
    if ($_.SideIndicator -eq '=>') {
        $_.SideIndicator = "Group not found for $ReferenceUser."
        }
    elseif ($_.SideIndicator -eq '<=') {
        $_.SideIndicator = "Group not found for $ComparisonUser."
        }
        $_
        }

$co
}