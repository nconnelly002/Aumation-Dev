



param([string]$department)

$company = "Edelstein & Co"

switch($department){
    'Tax' {
        $department = 'OU=Tax_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Tax'
    }
    'Admin' {
        $Department = 'OU=Admin_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Admin'
    } 
    'Audit' {
        $Department = 'OU=Audit_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Audit'
    } 

    'Healthcare' {
        $Department = 'OU=Healthcare_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Healthcare'
    } 

    'HR' {
        $Department = 'OU=HR_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'HR'

    }
    'IT' { 
        $Department = 'OU=IT_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local' 
        $dept = 'IT'
    }
    'MCS' {
        $Department = 'OU=MCS_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'MCS'
    }
    'Billing' {
        $Department = 'OU=Payroll_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Billing'
    }
    'Gold' {
        $Department = 'OU=RJGold_BU_Temp,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        'RJGold'
    }
    'Valuations' {
        $Department = 'OU=Valuations_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local' 
        $dept = 'Valuation'
    }
    'Marketing'{
        $department = 'OU=Marketing_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Marketng'
    }
    'Test'{
        $department = 'OU=Test_BU,OU=Users,OU=MyBusiness,DC=edelsteincpa,DC=local'
        $dept = 'Migrated_users'
    }
}

$users = Get-ADUser -filter * -SearchBase $department -Properties *

foreach($user in $users){
    set-aduser -Identity $user.SamAccountName -Department $dept -Company $company
}