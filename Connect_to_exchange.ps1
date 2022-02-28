#Connect to Exchange Online PowerShell
 Param
 (
    [Parameter(Mandatory = $false)]
    [switch]$Disconnect,
    [switch]$MFA,
    [string]$UserName, 
    [string]$Password
 )
 #Disconnect existing sessions
 if($Disconnect.IsPresent)
 {
  Get-PSSession | Remove-PSSession
  Write-Host All sessions in the current window has been removed. -ForegroundColor Yellow
 }
 #Connect Exchnage Online with MFA
 elseif($MFA.IsPresent)
 {
  #Check for MFA mosule
  $MFAExchangeModule = ((Get-ChildItem -Path $($env:LOCALAPPDATA+"\Apps\2.0\") -Filter CreateExoPSSession.ps1 -Recurse ).FullName | Select-Object -Last 1)
  If ($MFAExchangeModule -eq $null)
  {
   Write-Host  `nPlease install Exchange Online MFA Module.  -ForegroundColor yellow
   Write-Host You can install module using below blog : `nLink `nOR you can install module directly by entering "Y"`n
   $Confirm= Read-Host Are you sure you want to install module directly? [Y] Yes [N] No
   if($Confirm -match "[yY]")
   {
     Write-Host Yes
     Start-Process "iexplore.exe" "https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application"
   }
   else
   {
    Start-Process 'https://o365reports.com/2019/04/17/connect-exchange-online-using-mfa/'
    Exit
   }
   $Confirmation= Read-Host Have you installed Exchange Online MFA Module? [Y] Yes [N] No
   if($Confirmation -match "[yY]")
   {
    $MFAExchangeModule = ((Get-ChildItem -Path $($env:LOCALAPPDATA+"\Apps\2.0\") -Filter CreateExoPSSession.ps1 -Recurse ).FullName | Select-Object -Last 1)
    If ($MFAExchangeModule -eq $null)
    {
     Write-Host Exchange Online MFA module is not available -ForegroundColor red
     Exit
    }
   }
   else
   { 
    Write-Host Exchange Online PowerShell Module is required
    Start-Process 'https://o365reports.com/2019/04/17/connect-exchange-online-using-mfa/'
    Exit
   }   
  }
  
  #Importing Exchange MFA Module
  write-host aaaa
  . "$MFAExchangeModule"
  Connect-EXOPSSession -WarningAction SilentlyContinue | Out-Null
 }
 #Connect Exchnage Online with Non-MFA
 else
 {
  if(($UserName -ne "") -and ($Password -ne "")) 
  { 
   $SecuredPassword = ConvertTo-SecureString -AsPlainText $Password -Force 
   $Credential  = New-Object System.Management.Automation.PSCredential $UserName,$SecuredPassword 
  } 
  else 
  { 
   $Credential=Get-Credential -Credential $null
  } 
  
  $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection
  Import-PSSession $Session -DisableNameChecking -AllowClobber -WarningAction SilentlyContinue | Out-Null
 }

 #Check for connectivity
  if(!($Disconnect.IsPresent)){
 If ((Get-PSSession | Where-Object { $_.ConfigurationName -like "*Exchange*" }) -ne $null)
 {
  Write-Host `nSuccessfully connected to Exchange Online
 }
 else
 {
  Write-Host `nUnable to connect to Exchange Online. Error occurred -ForegroundColor Red
 }}

# SIG # Begin signature block
# MIIFuQYJKoZIhvcNAQcCoIIFqjCCBaYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXOHRq2r5pDWITwgdEixATpzc
# ut+gggNCMIIDPjCCAiqgAwIBAgIQa2jIXWVc86pBw3QBGHJpATAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0yMTA0MDgyMDUwMDZaFw0zOTEyMzEyMzU5NTlaMBoxGDAWBgNVBAMTD1Bvd2Vy
# U2hlbGwgVXNlcjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMHQ/bqA
# FBBiOodaLTG/35efABVd7TtGTiL+eVPH9h/BkQP9x6M85+i3Mbc9qF2cmfRYaJ8w
# 0RS6jz3bZo0l9wHM1G99Ti7s45aEryHQgdtJbL+isF6Vr95XBqoW6+V4patp7SXH
# +ThFUcIQMpKpcV5dgLdg3/Yi4m1vQwdzqEuSRP2ZGEoLXJzlx5bnRVEoBTKFrhma
# kzMdudPxaY4WIC3u3WE2xz0aDCterbBu2R3G/9CrLvq3UZXZpl8JiQo181BGBhSk
# RI89t/RQGj6jw7A/8H4s/Lk+a2jUrZSxUhtfp+nSDw2XNOTAsKBK/KoFduS2HwTv
# xORbobENeM58DN0CAwEAAaN2MHQwEwYDVR0lBAwwCgYIKwYBBQUHAwMwXQYDVR0B
# BFYwVIAQune6ViQ02/YnI1mFx7VheKEuMCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwg
# TG9jYWwgQ2VydGlmaWNhdGUgUm9vdIIQ0qq4t53KQ5ZBzOjr4dEvezAJBgUrDgMC
# HQUAA4IBAQBGVg/pG3VPO78hyRW8EEjJx8OH1hgo8Rd0/QoxukqeGoP60ds4AJS5
# RGmrqjxBF3NistHgD0hGFNcobRIBjs4Svx8u6mIfU3zmUYRGiqIOvq4K3naROoTW
# FUWgmTl7CYaWRgt+LbNhop0dsRAeymBichlgS7VwCjJghsQf9W1uAwaYV77Coj+x
# 35Vb+2bBl4PwCVhAS5ztxcMrC0HXIH/Iu6dWlm0NoyAC/ljVB38WqfZsZi8yn8jg
# NgrRoNg1TsBp0waLsVkCNYrNiF9ffDXtrIXywCOd1QGTaKJS5xiCcBmjcrUBexH0
# I169327JzWMn9gafLaBHs4148mD9Svn0MYIB4TCCAd0CAQEwQDAsMSowKAYDVQQD
# EyFQb3dlclNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3QCEGtoyF1lXPOqQcN0
# ARhyaQEwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFN1cV0Qh62YgGvkBcOsv1lpZZaicMA0GCSqG
# SIb3DQEBAQUABIIBAEnM8Dk9Qet+0mv9/+ZLoR3jfEaXqbA37Y4IVPUgIu8UWen6
# N4H1W4/QAVOShjf4dF4X73nxjbvlzeMQW+0TDdSumouquLoTFiemxojsBADrlm51
# MJO+5Ov6W5USjPRHuSALbRi0+Vu1pJYlItIsmWr9Y8+HLiYPKJSUyMZc+DifOGbh
# K2JCz3BwXV9nYZyfpg+EloITPQxy5zvIOE5RNdMHV+jzx0+0jl83BHcQUwPFTIvn
# Vzc5RL3DwK5cFsveWqS2eWtsNz8mKUPH5C+Nm+dAE7jL0XiniO2a/BFnDEiF+FPR
# szagKhne8R4yX24Uep0wB5yIJYqitmkhAlyYegs=
# SIG # End signature block
