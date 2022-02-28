


write-host ="###############################################################################################################" -ForegroundColor Green
write-host ="############################################## Edelstein Network utility ######################################" -ForegroundColor Yellow
write-host ="###############################################################################################################" -ForegroundColor Green

$citrixCpu = get-adgroupmember -Identity Citrix
$runagain = 't'


while($runagain -like 't'){

write-host ""
write-host ""
Write-Host "Which service would you like to test" -ForegroundColor red
write-host
write-host "1 = Test connection to Citrix application servers" -ForegroundColor Yellow
write-host ""
Write-host "2 = Check Status of Citrix Print Service on Application servers" -foregroundcolor yellow
write-host ""
write-host '3 = Restart the Engagement Server SQL Service' -ForegroundColor Yellow
Write-host ""
Write-host '4 = Apply a Group Policy Update to each of the Application servers' -foregroundcolor yellow
write-host ""
write-host '5 = Delete content in downloads folders on Citrix VDA Servers' -ForegroundColor Yellow

switch (read-host) {
    2 {
        write-host "Citrix Print Service" -ForegroundColor Green
        foreach ($cpu in $citrixCpu) {
            if (test-connection -ComputerName $cpu.name -count 1 -ErrorAction SilentlyContinue) {
                invoke-command -ComputerName $cpu.name -ScriptBlock { get-service cpsvc }
                Write-Host "Would you like to start the Citrix Print Service?" -ForegroundColor Yellow
                $answer = read-host "Y/N" 
                if ($answer -like 'y') {
                    invoke-command -ComputerName $cpu.name -scriptblock { start-service cpsvc 
                    get-service cpsvc}
                }
            }else{
            write-host "Server is down" -ForegroundColor Red
            }
        }
    }
 
    1{
        write-host "Checking server status now..."  -foregroundcolor green
        foreach ($cpu in $citrixCpu) {
            if (test-connection -ComputerName $cpu.name -count 1 -ErrorAction SilentlyContinue) {
                invoke-command -ComputerName $cpu.name -ScriptBlock { 
                    write-host "This server is up" -ForegroundColor green | hostname
                }
            }
            else { write-host $cpu.name 'is down' -ForegroundColor red } 
        }
    }

    3{ 
        write-host "restarting Engagement SQL Service" -foregroundcolor Green
        start-sleep 2
        write-host "WARNING: This can cause disruptions in the applications preformance, are you sure you want to continue? Y/N" -foregroundcolor Yellow 
        $answer = read-host
        if($answer -like 'y'){
            invoke-command -ComputerName edel-engmt -scriptblock{ restart-service 'MSSQL$PROFXENGAGEMENT' }
            invoke-command -ComputerName edel-engmt -scriptblock{ restart-service 'PFXSYNPFTService'}

        }
    }
    4{
        write-host "Preforming a group policy update on all of the Application Servers..." -ForegroundColor Green
        foreach ($cpu in $citrixCpu) {
            if (test-connection -ComputerName $cpu.name -count 1 -ErrorAction SilentlyContinue) {
                invoke-command -ComputerName $cpu.name -ScriptBlock { hostname
                gpupdate }
            }else{
            write-host "server is down" -ForegroundColor Red
            }

                
    }
    write-host "The group policy update is complete" -ForegroundColor Green
}
5{
    $servers = get-adgroupmember citrix
    foreach($cpu in $servers){invoke-command -ComputerName $cpu.name -ScriptBlock{set-location 'C:\script\'
.\delete_downloads.ps1 }}
}
}

write-host 'Do you want to choose another option? T/F'
$runagain =  read-host 
}
