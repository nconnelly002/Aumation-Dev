

param ($username)

if($username -ne ''){
    Write-host "Please enter valid username"
    $username =read-host
}

$upn = "$username@edelsteincpa.com"
write-host $groups
$user = get-aduser $username
$groups =Get-ADPrincipalGroupMembership  -Identity $user
$firstname = $user.givenname 
$lastname = $user.Surname
$fullname = $user.Name
$myemail = get-aduser $env:USERNAME


Write-host "Please verify that this is the user you would like to disable"
Write-host "First Name:" $user.givenname 
Write-host "Last Name:" $user.Surname
Write-host "Username:" $user.UserPrincipalName
read-host "Press enter to continue:"

write-host "Enter the email this will be forwaded to:"
$Fwdto = read-host
#==========================================================================================================================================
#                                     Disables Active Directory Account
#==========================================================================================================================================

disable-adaccount $user
foreach($group in $groups){
    Remove-ADGroupMember -Identity $group.Name -Members $user -Confirm:$false -ErrorAction SilentlyContinue
}

#===========================================================================================================================================
#                                   Unprovision Office 365 and forward emails 
#===========================================================================================================================================



set-location 'S:\IT Department\Network Service Tools'
.\Connect_to_exchange.ps1 -MFA
$cred = get-credential

Set-Mailbox -Identity $upn -ForwardingAddress $Fwdto -DeliverToMailboxAndForward $true

set-mailbox -Identity $upn -Type shared

Connect-MsolService -Credential $Cred

Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses 'edelsteincpa:ENTERPRISEPACK', 'edelsteincpa:RIGHTSMANAGEMENT'


write-host "check this"

#=========================================================================================================================
#                                                   Send email 
#=========================================================================================================================
Write-host "Preparing email" -ForegroundColor Green
start-sleep -seconds 5
$encrypted = Get-Content 'S:\IT Department\Automation\pass.txt' | Convertto-SecureString
$emailusername = 'support@edelsteincpa.com'
$credential = New-Object System.Management.Automation.PsCredential($emailusername, $encrypted)

$body =
@"
<brHello, 
>
<br><br>This users emails will be fowarded to you for the next 30 days in accordance with firm policy. In 30 days we will reach out to you and request permison to purge this user's account.

<br><br>
Sincerly,
<br>The Edelstein IT Team
"@


## Define the Send-MailMessage parameters
$mailParams = @{
    SmtpServer                 = 'smtp.office365.com'
    Port                       = '587'
    UseSSL                     = $true 
    Credential                 = $credential
    From                       = 'support@edelsteincpa.com'
    To                         = $Fwdto
    Subject                    = " $firstname $lastname 's  emails have been forwarded to you "
    Body                       = $Body
    DeliveryNotificationOption = 'OnFailure'
    priority                   = 'high'

}
## Send the message
Send-mailmessage @mailParams -BodyAsHtml
##############################################add outtlook event########################################################################################################
$ol = New-Object -ComObject Outlook.Application
$meeting = $ol.CreateItem('olAppointmentItem')
$meeting.Subject = "Termination $fullname emails going to $Fwdto"
$meeting.Body = 'Can we purge this account?'
$meeting.Location = 'Virtual'
$meeting.ReminderSet = $true

$meeting.Importance = 1
$meeting.MeetingStatus = [Microsoft.Office.Interop.Outlook.OlMeetingStatus]::olMeeting
$meeting.Recipients.Add('nconnelly@edelsteincpa.com')
$meeting.Recipients.Add('mbisso@edelsteincpa.com')
$meeting.ReminderMinutesBeforeStart = 15
$meeting.Start = [datetime]::Today.Adddays(30)
$meeting.Duration = 5
$meeting.Send()  