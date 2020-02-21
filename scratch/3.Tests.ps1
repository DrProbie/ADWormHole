. $PSScriptRoot\3.ps1

function TestUser([string] $DisplayName, [datetime] $LastLogonTimeStamp)
{
    $user = New-Object Microsoft.ActiveDirectory.ADUser
    $user.DisplayName = $DisplayName
    $user.LastLogonTimeStamp =  $LastLogonTimeStamp

    return $user

    Describe 'Disable-StaleADUser' {
        $today = New-Object DateTime(2000,1,1)

        Mock Get-Date {return $today}

        Mock Get-ADUser {
            TestUser -DisplayName 'Thirty' -LastLogonTimeStamp $today.AddDays(-30)
            TestUser -DisplayName 'Forty' -LastLogonTimeStamp $today.AddDays(-40)
            TestUser -DisplayName 'Fifty' -LastLogonTimeStamp $today.AddDays(-50)
            TestUser -DisplayName 'Sixty' -LastLogonTimeStamp $today.AddDays(-60)
        }

        Mock Disable-ADAccount
        
        It 'Disables the correct accounts when DaysToExpire is set to 40' {
            Disable-StaleADUser -DaysToExpire 40 -DomainName WhoCares

            Assert-MockCalled Disable-ADAccount -Scope It -Times 0 -ParameterFilter {$Identity.DisplayName -eq 'Thirty'}
            Assert-MockCalled Disable-ADAccount -Scope It -Times 0 -ParameterFilter {$Identity.DisplayName -eq 'Forty'}
            Assert-MockCalled Disable-ADAccount -Scope It -Times 1 -ParameterFilter {$Identity.DisplayName -eq 'Fifty'}
            Assert-MockCalled Disable-ADAccount -Scope It -Times 1 -ParameterFilter {$Identity.DisplayName -eq 'Sixty'}
        }
    }
}