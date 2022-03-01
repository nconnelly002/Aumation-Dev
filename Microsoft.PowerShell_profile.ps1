
Write-host "Welcome" $env:UserName -ForegroundColor Blue
Write-host "sync = Is a custom command for Edelstein to Sync the local Active Directory with Office 365"-ForegroundColor Green
write-host 
write-host 'application-services = Custom tool to check various application services and Office 365 Licensing' -ForegroundColor Green
write-host 
write-host "Upgrade-profile = updates powershell profile"

set-alias -name sync -Value 'S:\IT Department\Automation\ADSynce.ps1'
set-alias -name new-hire -Value 'S:\IT Department\Automation\Create_users.ps1'
set-alias -Name ifconfig ipconfig
Set-Alias -name manage-license -Value 'S:\IT Department\Automation\manage-officelicenses.ps1'
Set-Alias -name exchange -Value 'S:\IT Department\Automation\Connect_to_exchange.ps1' 
Set-Alias -Name remove-user -value 'S:\IT Department\Automation\remove-user.ps1'
set-alias -name application-services -Value 'S:\IT Department\Automation\Network_services.ps1'