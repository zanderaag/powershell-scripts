<#
.SYNOPSIS
    This script extracts errors from a local or domain-joined computer from Event Viewer and displays the results in a formatted HTML report.

.DESCRIPTION
    By specifying a specific start date, this script will extract all the errors from the specified PC and format it into an HTML report.
    Parameters such as -PCName and -StartPoint can be used as well if you choose to run this like a cmdlet.

.PARAMETER PCName
    The name of the computer, either local or domain-joined, that you will be querying for results.  

.PARAMETER StartPoint
    The date at which you wish the reports to begin from.

.EXAMPLE
    Get-ComputerLogs -PCName prefix-computernumber -StartPoint Yesterday
    Get-ComputerLogs -PCName prefix-computernumber -StartPoint TwoDaysAgo
    Get-ComputerLogs -PCName prefix-computernumber -StartPoint LastWeek
    Get-ComputerLogs -PCName prefix-computernumber -StartPoint LastMonth
#>
function Get-ComputerLogs {

 Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $PCName,
         [Parameter(Mandatory=$true, Position=1)]
         [string] $StartPoint
         )

#replace prefixes with organizationial-specific naming scheme prefix
$prefixes = @('x','y','z')
$regex = '^(' + (($prefixes | ForEach-Object { 
[regex]::Escape($_) + '[a-zA-Z0-9_-]{1,' + (15 - $_.Length) + '}' }) -join '|') + ')'

#Test to ensure the user is typing in a valid NetBIOS name.
if ($PCName -notmatch $regex) {
    Write-Warning "This is not a valid computer name. Please try again with an appropriate name."
    break
    }
elseif ($PCName -match $regex) {
    }

#Test to see if the user is providing the appropriate parameter value.
if ($StartPoint -ccontains "yesterday") {
    $StartPoint = Get-Date (Get-Date).AddDays(-1)
    }
elseif ($StartPoint -ccontains "twodaysago") {
    $StartPoint = Get-Date (Get-Date).AddDays(-2)
    }
elseif ($StartPoint -ccontains "lastweek") {
    $StartPoint = Get-Date (Get-Date).AddDays(-7)
    }
elseif ($StartPoint -ccontains "lastmonth") {
    $StartPoint = Get-Date (Get-Date).AddDays(-35)
    }
else {
    Write-Warning "The parameter -StartPoint only accepts three values at this current time: Yesterday, TwoDaysAgo, and LastWeek, and LastMonth."
    break
    }

#Declare CSS styling to make the report user-friendly.
[string]$CSS= @'
    <style>
    body {font-family:Verdana;
           font-size:8pt; 
           background: #2a2a30}
    h2 {color:white;
        text-align:center;
        text-decoration:underline;
        font-size:18pt;}
    th { color:yellow;
         background-Color:black; }
    tr {color:white}
    TR:Nth-Child(even) {Background-Color: #070708;}
    table, tr, td, th {padding: 2px; margin: 0px;text-align: center;vertical-align:top}
    table {margin-left: auto;margin-right: auto;}
    </style>
'@

#Variables for the date as to which you want to start collecting logs from.
$today = Get-Date
$filedate = Get-Date -Format "dd-MM-yyyy"

#Get the log errors after a certain date from the Application, System, and Security sections of Event Viewer.
$applogs = Get-EventLog -ComputerName $PCName -LogName Application -After $StartPoint | where {$_.EntryType -eq "Error"} | select EntryType,Source,TimeGenerated,Message
Write-Host -ForegroundColor Green "Application event log finished."
$syslogs = Get-EventLog -ComputerName $PCName -LogName System -After $StartPoint | where {$_.EntryType -eq "Error"} | select entrytype,source,TimeGenerated,Message
Write-Host -ForegroundColor Green "System event log finished."
$securelogs = Get-EventLog -ComputerName $PCName -LogName Security -After $StartPoint | where {$_.EntryType -eq "FailureAudit"} | select entrytype,source,TimeGenerated,Message
Write-Host -ForegroundColor Green "Security event log finished."

#Convert the variables above into HTML data and output it into a report and open it.
$applogs | ConvertTo-Html | Out-File "C:\users\$env:USERNAME\Event Viewer Report - $PCName - $filedate.html" -Force
$syslogs | ConvertTo-Html | Out-File -Append "C:\users\$env:USERNAME\Event Viewer Report - $PCName - $filedate.html" -Force
$securelogs | ConvertTo-Html -Head $CSS | Out-File -Append "C:\users\$env:USERNAME\Event Viewer Report - $PCName - $filedate.html" -Force

#Let the admin know script is finished and attempts to open the report
Write-Host -ForegroundColor Green "Script complete! The file is located in C:\users\$env:USERNAME\Event Viewer Report - $PCName - $filedate.html"
Invoke-Item "C:\users\$env:USERNAME\Event Viewer Report - $PCName - $filedate.html" 

#Redundant clear of all variables set so they do not conflict with any other variables present in your environment.
$StartPoint = $null
$PCName = $null
$prefixes = $null
$regex = $null
$linebreak = $null
$filedate = $null
$today = $null
$applogs = $null
$syslogs = $null
$securelogs = $null
}

