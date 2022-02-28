param ([string]$user)

if($user -eq ''){
   write-host 'Please enter a valid username:'
   $user = read-host 
}

$userObject = get-aduser $user -properties *

$title = read-host 'What is the users new title?'

set-aduser  $user -title $title

$department = $userObject.title 

write-host $department

Switch ($Department) {
   'Tax' {
    if($Department -like '*Tax*'){
       Add-ADGroupMember -Identity 'Tax_Partners' -Members $userObject
     }
     
     if($title -like 'Principal'){
         Add-ADGroupMember Principals -Members $userObject
         }
     if(($title -like '*Associate') -and ($Department -like '*tax*')){
         Add-ADGroupMember -Identity 'Tax_Associates' -Members $userObject
         }
     if(($title -like '*Manager') -and ($Department -like '*tax*')){
         Add-ADGroupMember -Identity 'Tax_Managers' -Members $userObject
     }
     if(($title -like 'Supervisor') -and ($Department -like '*tax*')){
         Add-ADGroupMember -Identity 'Tax_Supervisors' -Members $userObject
     }
     if(($title -like 'Supervisor') -or ($title -like '*Manager') -or ($title -like 'Partner') -and ($Department -like '*tax*')){
         Add-ADGroupMember -Identity 'Tax_Leadership' -Members $userObject
     }
     
   }
}
if($title -like 'Partner'){
   Add-ADGroupMember Partners -Members $userObject
}