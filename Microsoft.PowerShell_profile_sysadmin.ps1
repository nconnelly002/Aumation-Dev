
Write-host "Welcome" $env:UserName -ForegroundColor Blue
Write-host "sync = Is a custom command for Edelstein to Sync the local Active Directory with Office 365"-ForegroundColor Green
write-host
Write-Host 'new-hire = Is a custom command to create a new hire in out system to Edelstein Specifications in Active Directory and in Office 365'-ForegroundColor Green
write-host
write-host "remove-user = Disable user in active directory, configures email forwarding and converts to shared mail box, also removes licenses "-ForegroundColor Green
write-host
Write-host "manage-license + is a multi functional tool with sever options, 'exchange -usename user you want to edit or configure' "-ForegroundColor Green
write-host
write-host 'exchange = to connect to Office 365 Exchange'-ForegroundColor Green
write-host 
write-host 'application-services = Custom tool to check various application services and Office 365 Licensing' -ForegroundColor Green
Write-host 
write-host 'update-profile' -ForegroundColor Green

set-alias -name sync -Value 'S:\IT Department\Automation\ADSynce.ps1'
set-alias -name new-hire -Value 'S:\IT Department\Automation\Create_users.ps1'
Set-Alias -name manage-license -Value 'S:\IT Department\Automation\manage-officelicenses.ps1'
Set-Alias -name exchange -Value 'S:\IT Department\Automation\Connect_to_exchange.ps1' 
Set-Alias -Name remove-user -value 'S:\IT Department\Automation\remove-user.ps1'
set-alias -name application-services -Value 'S:\IT Department\Automation\Network_services.ps1'
Set-Alias -Name 'Update-Profile' -Value 'S:\IT Department\automation Dev\Push_Profile.ps1'
