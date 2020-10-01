<#This script will refrence the default xml layout file which determines which extensions are tied to which app
and will re-associate each app with its default extensions as per the XML file.
#>

Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
