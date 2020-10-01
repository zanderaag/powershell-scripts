<#
.SYNOPSIS
    This script applies custom settings and configurations to a laptop being deployed for a new/existing user.
 
.DESCRIPTION
    This script will do the following: Deploy a custom task bar, turn UAC off, disable Web search and Cortana, pin custom links to the users Internet Explorer
    toolbar, create and apply a custom power plan, adds old Windows Photo Viewer back into list of default apps, fix an issue with Harmon.ie and Windows 1809/Office 1808,
    and a few other taskbar related actions.

.EXAMPLE
    New-UserConfig

#>

<#Things left to work out.
Sending email using PowerShell.
#>

#Store name of the user you are configuring and ensure the name is correct with a loop.
function New-UserConfig {
$configuser = $env:USERNAME

#Set variables for various absolute path names.
$outlook = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
$word = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
$excel = "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
$powerp = "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"
$internetexplorer = "C:\Program Files\internet explorer\iexplore.exe"
$chrome = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$onenote = "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
$teams = "C:\Users\$configuser\AppData\Local\Microsoft\Teams\current\Teams.exe"
$officelist = @("$outlook","$word","$excel","$powerp","$internetexplorer","$chrome","$onenote","$teams")

#Prompt box asking for user to ensure that Office365 suite is installed.
Add-Type -AssemblyName PresentationFramework
$warningbox = [System.Windows.MessageBox]::Show('This script requires Office365 to be fully installed. Are you sure you want to proceed?','Customization Script','YesNoCancel','Error')
switch ($warningbox)
{
    'Yes'{continue;}
    'No'{exit;}
    'Error'{exit;}
    Default {exit;}
}

if (Test-Path $outlook) {Write-Host "Outlook exists."} else {Write-Warning "$outlook does not exist!"}
if (Test-Path $word) {Write-Host "Word exists."} else {Write-Warning "$word does not exist!"}
if (Test-Path $excel) {Write-Host "Excel exists."} else {Write-Warning "$excel does not exist!"}
if (Test-Path $powerp) {Write-Host "PowerPoint exists."} else {Write-Warning "$powerp does not exist!"}
if (Test-Path $internetexplorer) {Write-Host "Internet Explorer exists."} else {Write-Warning "$internetexplorer does not exist!"}
if (Test-Path $chrome) {Write-Host "Google Chrome exists."} else {Write-Warning "$chrome does not exist!"}
if (Test-Path $onenote) {Write-Host "OneNote exists."} else {Write-Warning "$onenote does not exist!"}
if (Test-Path $teams) {Write-Host "Teams exists."} else {Write-Warning "$teams does not exist!"}

$warningbox3 = [System.Windows.MessageBox]::Show((Test-Path $officelist), 'Office 365 Test-Path Results','Ok')

Write-Warning "DO NOT PROCEED FURTHER UNTIL THE PREVIOUS MESSAGE BOX SHOWS ALL TRUE!"

do {
$configchoice2 = Read-Host "Are you sure the pre-requisites are inplace for this script to be ran correctly? [y/n]"
if ($configchoice2 -eq "y") {
    continue
    }
elseif ($configchoice2 -eq "n") {
    exit
    }
else {
    Write-Warning "Please select either the Y or the N button on your keyboard to proceed."
    $configchoice2
    }
} until ($configchoice2 -eq "y") 

#Disable Cortana and Web Search (RUN AS LOCAL ADMINISTRATOR)
New-Item -Path HKLM:\Software\Policies\Microsoft\Windows -Name 'Windows Search' -Type Key –Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\'Windows Search'\ -Name 'AllowCortana' -Type Dword -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\'Windows Search'\ -Name 'ConnectedSearchUseWeb' -Type Dword -Value 0 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\'Windows Search'\ -Name 'DisableWebSearch' -Type Dword -Value 1 -Force
New-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\'Windows Search'\ -Name 'ConnectedSearchUseWebOverMeteredConnections' -Type Dword -Value 0 -Force
   
#Set UAC to Off (RUN AS LOCAL ADMINISTRATOR)
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name 'EnableLua' -Value 0 -Force

#Wipe old taskbar configuration (RUN AS LOCAL ADMINISTRATOR OR LOCAL USER)
Remove-Item "C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" -ErrorAction SilentlyContinue

#Configure custom taskbar (RUN AS LOCAL ADMINISTRATOR OR LOCAL USER)
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Outlook.lnk")
$shortcut.TargetPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook.lnk"
$shortcut.Save()
     
$shell1 = New-Object -ComObject WScript.Shell
$shortcut1 = $shell1.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Word.lnk")
$shortcut1.TargetPath = "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
$shortcut1.Save()
     
$shell2 = New-Object -ComObject WScript.Shell
$shortcut2 = $shell2.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Excel.lnk")
$shortcut2.TargetPath = "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
$shortcut2.Save()
     
$shell3 = New-Object -ComObject WScript.Shell
$shortcut3 = $shell3.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\PowerPoint.lnk")
$shortcut3.TargetPath = "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"
$shortcut3.Save()

$shell4 = New-Object -ComObject WScript.Shell
$shortcut4 = $shell4.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Internet Explorer.lnk")
$shortcut4.TargetPath = "C:\Program Files\internet explorer\iexplore.exe"
$shortcut4.Save()

$shell5 = New-Object -ComObject WScript.Shell
$shortcut5 = $shell5.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Google Chrome.lnk")
$shortcut5.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$shortcut5.Save()

$shell6 = New-Object -ComObject WScript.Shell
$shortcut6 = $shell6.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\File Explorer.lnk")
$shortcut6.TargetPath = "%WINDIR%\explorer.exe"
$shortcut6.Save()

$shell7 = New-Object -ComObject WScript.Shell
$shortcut7 = $shell7.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Teams.lnk")
$shortcut7.TargetPath = "C:\Users\$configuser\AppData\Local\Microsoft\Teams\current\Teams.exe"
$shortcut7.Save()

$shell8 = New-Object -ComObject WScript.Shell
$shortcut8 = $shell8.CreateShortcut("C:\Users\$configuser\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\OneNote 2016.lnk")
$shortcut8.TargetPath = "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
$shortcut8.Save()

$shell9 = New-Object -ComObject WScript.Shell
$shortcut9 = $shell12.CreateShortcut("C:\users\$configuser\Favorites\Links\O365 Web Portal.url")
$shortcut9.TargetPath = "https://portal.office365.com"
$shortcut9.Save()

$taskbandtest = Test-Path C:\Users\$configuser\Desktop\Taskband.reg
if ($taskbandtest) {
    reg import C:\Users\$configuser\Desktop\Taskband.reg
    }
elseif (!($taskbandtest)) {
    Write-Warning "The registry keyfile 'Taskband.reg' is missing from your desktop. Please acquire it and run the file in order to apply the custom taskbar."
    }

$w7phototest = Test-Path C:\Users\$configuser\Desktop\w7photoviewer.reg
if ($w7phototest) {
    reg import C:\Users\$configuser\Desktop\w7photoviewer.reg
    }
elseif (!($w7phototest)) {
    Write-Warning "The registry key file 'w7photoviewer.reg' is missing from your desktop. Please acquire it and run the file in order to change the default photo application."
    }

#Create Custom Plan (RUN AS LOCAL ADMINISTRATOR)
function CustomPowerPlan {

#Create the custom power plan based off the pre-existing Balanced plan.
powercfg -duplicatescheme 381b4222-f694-41f0-9685-ff5bb260df2e 
$planname = "Custom Plan"
Write-Warning "Please copy the GUID of the extra Balanced plan to create this custom power plan"
powercfg /list
pause
$newplanguid = Read-Host "Please paste the GUID you copied into the shell"
powercfg -changename $newplanguid "$planname"
powercfg /setactive $newplanguid

#Do nothing when lid closes on battery/power.
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

#Turn off the machine when the power button is pressed.
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

#Configure settings for monitor turning off and laptop going into standby/sleep mode.
powercfg -change -monitor-timeout-ac 60
powercfg -change -monitor-timeout-dc 60
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 60

#Display new power plan to confirm everything worked.
powercfg /list
}
CustomPowerPlan

#LOCAL ADMINISTRATOR SCRIPTS

#Set File explorer hidden files and file extensions tick to enabled (RUN AS LOCAL ADMINISTRATOR)
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty -Path $key -Name Hidden -Value 1 -Force
Set-ItemProperty -Path $key -Name HideFileExt -Value 0 -Force
Set-ItemProperty -Path $key -name ShowSuperHidden -Value 0 -Force
Set-ItemProperty -Path $key -name AutoCheckSelect -Value 0 -Force

#Configure starting page and Favorites toolbar in Internet Explorer (RUN AS LOCAL ADMINISTRATOR)
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name 'Search Page' -Value 'www.google.ca' -Force 
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Internet Explorer\Main' -Name 'Start Page' -Value 'www.google.ca' -Force

#Configure File Explorer ribbon to be pinned (RUN AS LOCAL ADMINISTRATOR)
$key2 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon'
Set-ItemProperty -Path $key2 -Name MinimizedStateTabletModeOff -Type Dword -Value 0 -Force
New-ItemProperty -Path $key2 -Name MinimizedStateTabletModeOn -Type Dword -Value 0 -Force

#Disable Task View, Search box and the People icon (RUN AS LOCAL ADMINISTRATOR)
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name 'ShowTaskViewButton' -Type Dword -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\ -Name 'SearchboxTaskbarMode' -Type Dword -Value 0 -Force
New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name 'People' -Force
Set-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name 'PeopleBand' -Value 0 -Force
Stop-Process -processname explorer
Write-Warning "PLEASE RESTART THE LAPTOP TO FINISH THE REST OF THE CONFIGURATION."

#Bug fix for Harmon.ie not loading in the sidebar but in its own seperate window
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\Options' -Name 'RenderForMonitorDpi' -PropertyType dword -Value '0' -Force -ErrorAction SilentlyContinue

#Set default printer for the laptop (NOT FUNCTIONAL YET)
#Placeholder for a selection of UNC pathnames for each global entities printer
$printershare = '\\path\to\printer'
$defaultprinter = New-Object -COM WScript.Network
$defaultprinter.SetDefaultPrinter($printershare)

#Assosciate the .pdf file extension with Adobe Acrobat DC or Adobe Acrobat 2017 Pro (Refusing to work even with A- Account and local admin)
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf\UserChoice -Name 'ProgId' -Value 'AcroExch.Document.DC' -Force
#New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.pdf\UserChoice -Name 'ProgId' -Value 'AcroExch.Document.DC' -Force

#Configure Folder Options privacy settings for Quick Access
#New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name 'ShowFrequent' -Type Dword -Value 0 -Force
#New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name 'ShowRecent' -Type Dword -Value 0 -Force
}