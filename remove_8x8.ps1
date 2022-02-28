Set-ExecutionPolicy RemoteSigned
$Exclusions = ("Administrator", "Default", "Public") 
$Profiles = Get-ChildItem -Path $env:SystemDrive"\Users" | Where-Object { $_ -notin $Exclusions } 
$AllProfiles = @() 
foreach ($Profile in $Profiles) {  
      $object = New-Object -TypeName System.Management.Automation.PSObject
      Remove-Item  -Recurse ($Profile.FullName + '\appdata\local\8x8-Work') -Confirm:$false -ErrorAction SilentlyContinue
      Remove-Item  -Recurse ($Profile.FullName + '\AppData\Roaming\8x8 Work') -Confirm:$false -ErrorAction SilentlyContinue
      remove-item  ($Profile.Fullnam + '\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\8x8 Inc') -Confirm:$false -ErrorAction SilentlyContinue
      }

$myapp = Get-WmiObject -Class Win32_product | where {$_.name -like '*8x8*'}
if($myapp.name -like "8x8 Work"){
$myapp.uninstall()
}