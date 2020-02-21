function Disable-StaleADUser
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string]
        $DomainName,
        [uint32]
        $DaysToExpire
    )

    $threshold = (Get-Date).AddDays(-$DaysToExpire)

    Get-ADUser  -Server $DomainName 
                -Properties LastLogonTimeStamp 
                -Filter * | 
            Where-Object {$_.LastLogonTimeStamp -lt $threshold} | 
            Disable-ADAccount
}