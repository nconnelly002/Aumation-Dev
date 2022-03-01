
Write-host "Welcome" $env:UserName -ForegroundColor Blue
Write-host "sync = Is a custom command for Edelstein to Sync the local Active Directory with Office 365"-ForegroundColor Green
write-host 
write-host 'application-services = Custom tool to check various application services and Office 365 Licensing' -ForegroundColor Green
write-host 
write-host "Upgrade-profile = updates powershell profile"

set-alias -name sync -Value 'S:\IT Department\Automation\ADSynce.ps1'
set-alias -Name ifconfig ipconfig
set-alias -name application-services -Value 'S:\IT Department\Automation\Network_services.ps1'
set-alias -name upgrade-profile -Value 'S:\IT Department\Automation\Push_Profile.ps1'