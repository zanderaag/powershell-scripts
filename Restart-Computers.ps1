# Run as domain/admin on Workstation

function Q3(){
#Get all AD computers except the current workstation
$ADComputers = Get-ADComputer -Filter "name -ne '$($env:COMPUTERNAME)'" | Select-Object -ExpandProperty Name

#foreach that isolates each computer
foreach ($comp in $ADComputers) {
    #Restart cmdlet that waits indefinitely until the computer has restarted
    Restart-Computer -ComputerName $comp -Wait
    #CIM instance that shows the Computer Name and Start up time
    Get-CimInstance -ComputerName $comp -ClassName Win32_OperatingSystem | 
    #select formated to nice names
    Select @{Name='AD Computer'; Expression={$_.csname}}, @{Name = 'Startup Time'; Expression={$_.lastbootuptime}}, 
    #calculated property that shows the IP Address in the same table    
    @{Name = 'IP Address'; Expression= {
        Get-NetIPAddress -CimSession $comp -AddressFamily IPv4 | Where-Object {$_.IPAddress -match "10.0.34."} | Select -ExpandProperty IPaddress
            }
        }
    }
}


Q3