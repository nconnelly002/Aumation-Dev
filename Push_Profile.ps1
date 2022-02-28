$a = whoami
$b = $a.split('\')
$username = $b[1]

if($username -like 'nconnelly002'){

    copy-item -path "S:\IT Department\Automation\Microsoft.PowerShell_profile_sysadmin.ps1" -destination \\edel-file\users\$username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
    
}else{
copy-item -path "S:\IT Department\Automation\Microsoft.PowerShell_profile.ps1" -destination \\edel-file\users\$username\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
}
