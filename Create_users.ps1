
param ([string]$firstname, [string]$middleinitial, [string]$lastname, [string]$title, [string]$Department)


Write-host "Checking Prerequisites" -ForegroundColor:DarkGreen
if (Get-Module -ListAvailable -Name AzureAD) {
    Write-Host "Azure AD installed" -ForegroundColor:Green

}
else {
    Write-Host "Azure AD is not installed, we will try to install now" -ForegroundColor Red
    Install-Module -Name AzureAD -Force
    
}

If (Get-Module -ListAvailable -name MSOnline ) {
    Write-host "MSOnline is installed" -ForegroundColor:Green
}
else {
    Write-Host "MSOnline is not installed, we will try to install now" -ForegroundColor Red
    Install-Module -Name MSOnline -Force
}

if (Get-Module -ListAvailable -name ActiveDirectory) {
    Write-host 'ActiveDirectory is installed' -ForegroundColor:Green
}
else {
    Write-host "Please install ActiveDirectory users and computers and try again"
}

#==================================================================================================================================
#Ensures script has information
#=================================================================================================================================

if ($firstname -eq '') {
    $firstname = Read-Host "Enter a first name"
}
if ($lastname -eq '') {
    $lastname = Read-Host "Enter a last name"
}
if ($Department -eq '') {
    $Department = Read-Host "Enter a Department"
}
if ($title -eq '') {
    $title = Read-Host "Enter a title"
}

if ($middleinitial -eq '') {
    $b = Read-Host "Does the user have a middle initial: True or False"
    try {
        $b = [System.Convert]::ToBoolean($b)
    }
    catch {
        Write-Host "Must enter True or False."
        $b = Read-Host -Prompt "Does the user have a middle initial: True or False"
        $b = [System.Convert]::ToBoolean($b)
    }
    if ($b -eq $true) {
        $middleinitial = read-host "Enter Middle Initial"
    }

}


if ($middleinitial -notlike '') {
    $middleinitial = $middleinitial.ToUpper()
    $middleinitial = "$middleinitial."
}

#==================================================================================================================================
#Ensures formating of user attributes
#=================================================================================================================================
$defaultGroup = 'Edelstein&CompanyLLP'
$firstname = $firstname.substring(0, 1).ToUpper() + $firstname.substring(1).tolower()
$middleinitial.ToUpper() + '.'
$lastname = $lastname.substring(0, 1).ToUpper() + $lastname.substring(1).tolower()
$title = $title.substring(0, 1).ToUpper() + $title.substring(1).tolower()
$Department = $Department.substring(0, 1).ToUpper() + $Department.substring(1).tolower()
$email = $firstname.substring(0, 1) + $lastname + '@edelsteincpa.com'
$email = $email.ToLower()

#====================================================================================================================================
# Based on the entry for the Department variable below determines OU and any Departmental groups they sure should be apart of by Default
#===================================================================================================================================

Switch ($Department) {
    'Tax' {
        $Department = 'OU=Tax_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = "Tax_Dept"
        $DeptAtt = "Tax"
        $knowb4 = 'Knowbe4_Tax'
        $distro = 'Tax_Department'
    }

        

    'Admin' {
        $Department = 'OU=Admin_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = "Admin_Dept"
        $DeptAtt = "Admin"
        $knowb4 = 'Knowbe4_Admin'
    } 
    'Audit' {
        $Department = 'OU=Audit_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = "Audit_Dept"
        $DeptAtt = "Audit"
        $knowb4 = 'Knowbe4_Audit'
        $distro = 'A&A Department'
    } 

    'Healthcare' {
        $Department = 'OU=Healthcare_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local' 
        $DeptGroup = 'Healthcare_dept' 
        $DeptAtt = "Healthcare"
        $knowb4 = 'Knowbe4_Healthcare'
        $distro = 'Healthcare'
    } 

    'HR' {
        $Department = 'OU=HR_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = 'Hr_dept'
        $DeptAtt = "HR"
        $knowb4 = 'Knowbe4_HR'
    }
    'IT' { 
        $Department = 'OU=IT_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local' 
        $DeptGroup = 'Marketng_Dept'
        $DeptAtt = "IT"
        $knowb4 = 'Knowbe4_IT'
    }
    'MCS' {
        $Department = 'OU=MCS_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = 'MCS_Dept'
        $DeptAtt = "MCS" 
        $knowb4 = 'Knowbe4_MCS'
    }
    'Billing' {
        $Department = 'OU=Payroll_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = 'Billing_Dept' 
        $DeptAtt = "Billing"
        $knowb4 = 'Knowbe4_Billing'
    }
    'Gold' {
        $Department = 'OU=RJGold_BU_Temp,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $DeptGroup = = 'RJGold'
        $DeptAtt = "RJGold"
        $knowb4 = 'Knowbe4_Gold'
    }
    'Valuations' {
        $Department = 'OU=Valuations_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local' 
        $DeptGroup = 'Valuation_Dept'
        $DeptAtt = "Valuation"
        $knowb4 = 'Knowbe4_Valuations'
    }
    'Test'{
        $Department = 'OU=Test_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $deptgroup = 'Test_dept'
    }
}






#=========================================================================================================================================
#                           Creates the user account Password
#=======================================================================================================================================


Do {
    Write-Host
    $isGood = 0
    $Password = Read-Host "Enter in the Password for the new user account:" -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $Complexity = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
 
    if ($Complexity.Length -ge $PasswordLength) {
        Write-Host
    }
    else {
        Write-Host "Password needs $PasswordLength or more Characters" -ForegroundColor:Green
    }
 
    if ($Complexity -match "[^a-zA-Z0-9]") {
        $isGood++
    }
    else {
        Write-Host "Password does not contain Special Characters." -ForegroundColor:Green
    }
 
    if ($Complexity -match "[0-9]") {
        $isGood++
    }
    else {
        Write-Host "Password does not contain Numbers." -ForegroundColor:Green
    }
 
    if ($Complexity -cmatch "[a-z]") {
        $isGood++
    }
    else {
        Write-Host "Password does not contain Lowercase letters." -ForegroundColor:Green
    }
 
    if ($Complexity -cmatch "[A-Z]") {
        $isGood++
    }
    else {
        Write-Host "Password does not contain Uppercase letters." -ForegroundColor:Green
    }
 
}Until($password.Length -ge $PasswordLength -and $isGood -ge 3)

 
Write-Host 
Read-Host "Press Enter to Continue, and create the password"


#======================================================================================================================================
#                                                Create the username
#======================================================================================================================================


$username = "$($firstname.substring(0,1))${lastname}001"
$EaPrefBefore = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'
if (get-aduser $username) {
    $username = "$($firstname.substring(0,1))${lastname}002"
    if (get-aduser $username) {
        Write-Warning "No Acceptable username Schema could be created"
        return
    }
    
}
$username = $username.ToLower()
Write-Host "New User Information" -ForegroundColor DarkGreen
Write-host
write-host '==========================================================================='
Write-host
Write-Host "User Principal Name: $username@edelsteincpa.com" -ForegroundColor Green
Write-Host "Username: $username" -ForegroundColor Green
write-host "Firstname: $firstname" -ForegroundColor Green
write-host "Middle Initial:" $middleinitial -ForegroundColor:Green
write-host "Lastname: $lastname"-ForegroundColor Green
write-host "Title: $title" -ForegroundColor Green
Write-host "Department: $deptatt" -ForegroundColor Green
Write-Host "Email Adress: $email" -ForegroundColor Green
Write-host
Write-host
Read-Host "If information is correct please press enter."

 
$ErrorActionPreference = $EaPrefBefore
$newUserParams = @{
    'userPrincipalName'     = "$username@edelsteincpa.com"
    'name'                  = "$firstname $lastname"
    'GivenName'             = $firstname
    'surname'               = $lastname
    'Title'                 = $title
    'SamAccountName'        = $username
    'AccountPassword'       = (ConvertTo-SecureString $password -AsPlainText -Force)
    'Enabled'               = $true
    'initials'              = $middleinitial.ToUpper()
    'path'                  = $Department
    'ChangePasswordatlogon' = $false
    'DisplayName'           = "$firstname $lastname"
    'Description'           = "$firstname $middleinitial $lastname"
    'Department'            = $Deptatt
    'Company'               = 'Edelstein & Co'
    'EmailAddress'          = $email

}


#======================================================================================================================================
#                                    Adds user to groups
#======================================================================================================================================


New-aduser @newUserParams
Add-ADGroupMember -Identity $defaultGroup -Members $username
Add-ADGroupMember -Identity $DeptGroup -Members $username
Add-ADGroupMember -Identity $knowb4 -Members $username
if($distro -ne ''){
    Add-ADGroupMember -Identity $distro -Members $username
}
if($title -like 'Partner'){
    Add-ADGroupMember Partners -Members $username
    if($Department -like '*Tax*'){
        Add-ADGroupMember -Identity 'Tax_Partners' -Members $username
}
}
if($title -like 'Principal'){
    Add-ADGroupMember Principals -Members $username
    }
if(($title -like '*Associate') -and ($Department -like '*tax*')){
    Add-ADGroupMember -Identity 'Tax_Associates' -Members $username
    }
if(($title -like '*Manager') -and ($Department -like '*tax*')){
    Add-ADGroupMember -Identity 'Tax_Managers' -Members $username
}
if(($title -like 'Supervisor') -and ($Department -like '*tax*')){
    Add-ADGroupMember -Identity 'Tax_Supervisors' -Members $username
}
if(($title -like 'Supervisor') -or ($title -like '*Manager') -or ($title -like 'Partner') -and ($Department -like '*tax*')){
    Add-ADGroupMember -Identity 'Tax_Leadership' -Members $username
}


#===========================================================================
#Sync AD-Connect (Updates Office 365)
#===========================================================================


if (Test-Connection edel-scan) {
    Invoke-Command -ComputerName edel-scan -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }
    Write-Host "Starting Sync Service, please wait...." -ForegroundColor Green
    Start-Sleep -Seconds 30

}
else {
    Invoke-Command -ComputerName edel-ads1 -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }
    Write-Host "AD-Connect Sucessfull Sync" -BackgroundColor DarkGreen
    Write-Host "Starting Sync Service, please wait...." -ForegroundColor Green
    Start-Sleep -Seconds 30
    Write-Warning 'Kaseya Server is down'

}

#===========================================================================
#Verifying User is in Office365
#===========================================================================
Write-Host 'When prompted enter your Office 365 Username and Password' -ForegroundColor Green
Start-Sleep -Seconds 15

#$cred = get-credential
$upn = "$username@edelsteincpa.com"

#Must declare outside of Try..Catch or they won't persist
$Connected = $False
$Tries = 0

Do {
    Try { 
        Connect-MsolService -Credential (Get-Credential) -ErrorAction Stop
        $Connected = $True
    } 
    Catch {
        Write-Host $_.Exception.Message
        $Connected = $False
        $Tries++
    } 
}
Until ($Connected -eq $True -or $Tries -ge 5)

$user = Get-MsolUser -UserPrincipalName $upn -ErrorAction SilentlyContinue

if ($null -ne $user) {
    Write-Host "User account exist in Office 365" -ForegroundColor DarkGreen
    start-sleep -Seconds 15

    
}
else {
    Write-Host 'User not found'
    Write-Warning "Searching again"
    invoke-command -ComputerName edel-ads1 { Start-ADSyncSyncCycle -PolicyType Delta }
    Start-Sleep -Seconds 30
    $user = Get-MsolUser -UserPrincipalName $upn -ErrorAction SilentlyContinue
    if ($null -ne $user) {
        Write-host "Licensing product failed, try again?" -ForegroundColor Red
        $b = Read-Host "True or False"
        try {
            $b = [System.Convert]::ToBoolean($b)
        }
        catch {
            Write-Host "Unable to verify user in Ofiice 365, try again?"
            $b = Read-Host -Prompt "True or False"
            $b = [System.Convert]::ToBoolean($b)
        }
        if ($b -eq $true) {
            if (Test-Connection edel-ads1) {
                Invoke-Command -ComputerName edel-ads1 -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }
                Write-Host "Starting Sync Service, please wait...." -ForegroundColor Green
                Start-Sleep -Seconds 30
                
            }
            else {
                Invoke-Command -ComputerName edel-ads1 -ScriptBlock { Start-ADSyncSyncCycle -PolicyType Delta }
                Write-Host "AD-Connect Sucessfull Sync" -BackgroundColor DarkGreen
                Write-Host "Starting Sync Service, please wait...." -ForegroundColor Green
                Start-Sleep -Seconds 30
                Write-Warning 'Kaseya Server is down'
                
            }
        }
    }
    $user = Get-MsolUser -UserPrincipalName $upn -ErrorAction SilentlyContinue
    if ($null -ne $user) {
        Write-host "User verification failed, now exiting"
        exit

    }
}

$mf= New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$mf.RelyingParty = "*"
$mfa = @($mf)
#Enable MFA for a user
Set-MsolUser -UserPrincipalName "$username@edelsteincpa.com"-StrongAuthenticationRequirements $mfa


#=================================================================================
#               Assign License 
#=================================================================================

Set-MsolUser -UserPrincipalName $upn -UsageLocation US
Write-Host "Verifying Office 365 Configuration" -ForegroundColor Green
start-sleep -Seconds 15

Set-MsolUserLicense -UserPrincipalName $upn -AddLicenses 'edelsteincpa:ENTERPRISEPACK', 'edelsteincpa:RIGHTSMANAGEMENT'
Write-Host "Applying Licence information " -ForegroundColor Green
Start-Sleep -Seconds 15
$IsLicened = Get-MsolUser -UserPrincipalName $upn
write-host 
write-host $IsLicened 
Write-Host 'Setup complete' -ForegroundColor Green



#===========================================================================
# Send IT Welcome Email
#===========================================================================  
Write-host "Preparing email" -ForegroundColor Green
start-sleep -seconds 120
$encrypted = Get-Content 'S:\IT Department\Network Service Tools\xyz.txt' | ConvertTo-SecureString
$emailusername = 'support@edelsteincpa.com'
$credential = New-Object System.Management.Automation.PsCredential($emailusername, $encrypted)

$body =
@"
<br>Hello, 

<br><br>Edelstein IT would like to congratulate you on joining Edelstein & Co.  We wanted to provide you with some resources to guide you through the technology here at the firm. <br><br>

<a
href="https://edelsteincpa.sharepoint.com/:w:/r/it/_layouts/15/Doc.aspx?sourcedoc=%7B0C14B5CA-5EEA-4583-B14E-964C2ABDFE38%7D&file=Edelstein%20IT%20Application%20Information.docx&action=default&mobileredirect=true"
target="_blank">Edelstein IT Application Information.docx 
</a>

<br><br>In the link above you will find a document that will provide you with some useful information. When prompted, you will be asked to sign in.  Your user name will be first initial, last name 001 @ edelsteincpa.com.

<br><br>Example:jdoe001@edelsteincpa.com

<br><br>If you are ever having issues, feel free to submit an IT support ticket by emailing support@edelsteincpa.com. Our standard support hours are Monday through Friday, 8:30am to 5:00pm. We can be reached off hours in case of an emergency by dialing (339) 364-6909. If prompted, please leave a voicemail with a brief description of your issue and a return telephone number where you can be reached. For more information on our support model please click the link below.  We hope that you enjoy your time here at Edelstein & Co. and we look forward to providing the best possible service to you.<br><br> 

<a
href="https://edelsteincpa.sharepoint.com/it/SitePages/IT-Support-Model---Change.aspx"
target="_blank">Edelstein IT Support Model
</a> 

<br><br>Sincerely,
<br>The Edelstein IT Team

"@


## Define the Send-MailMessage parameters
$mailParams = @{
    SmtpServer                 = 'smtp.office365.com'
    Port                       = '587'
    UseSSL                     = $true 
    Credential                 = $credential
    From                       = 'support@edelsteincpa.com'
    To                         = $email
    Subject                    = "Welcome To Edelstein $firstname $lastname"
    Body                       = $Body
    DeliveryNotificationOption = 'OnFailure'
    priority                   = 'high'

}
   
## Send the message
Send-mailmessage @mailParams -BodyAsHtml
#============================================================================================
#                           Configure Active Sync Settings 
#============================================================================================

set-location -Path 'S:\IT Department\Network Service Tools'
.\connect_to_exchange -mfa

set-casmailbox -identity $upn -activesyncenabled $false

