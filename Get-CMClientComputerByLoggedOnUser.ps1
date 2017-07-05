<#
.SYNOPSIS
Get a list of computers where a specified user has last logged on.

.DESCRIPTION
This function performs a WMI SQL query against the SCCM database to determine to
which computers a specified user account has last logged.

.PARAMETER UserName
Provide a username.

.PARAMETER SiteServer
Specify the name or FQDN of your SCCM site server. By default it gathers the site server
from the computer from which the function is called.

.PARAMETER SiteCode
Specify the site code of your SCCM environment. By default it gathers the site code
from the computer from which the function is called.

.PARAMETER Credential
Provide a credential object for accessing the site server.

.EXAMPLE
Get-CMClientComputerByLoggedOnUser -Username jsmith

Get the list of computers where jsmith last logged on.

.NOTES
Created by: Jason Wasser @wasserja
Modified: 7/5/2017 01:13:57 PM 
#>
function Get-CMClientComputerByLoggedOnUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('SamAccountName')]
        [string]$UserName,
        [string]$SiteServer = (Get-WmiObject -Namespace root\ccm -ClassName SMS_Authority).CurrentManagementPoint,
        [string]$SiteCode = (Get-WmiObject -Namespace root\ccm -ClassName SMS_Authority).Name.Split(':')[1],
        [System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    begin {}
    process {
        foreach ($User in $UserName) {
            Write-Verbose -Message "Gathering computers from where $User last logged on from Site Server $SiteServer using Site Code $SiteCode."
            $Query = "SELECT SMS_R_System.LastLogonUserName, SMS_R_System.Name, SMS_R_System.LastLogonTimestamp from SMS_R_System where LastLogonUserName='$User'"
            $Computers = Get-WmiObject -ComputerName $SiteServer -Namespace root/SMS/site_$SiteCode -Credential $Credential -Query $Query
            if ($Computers) {
                Write-Verbose 'Query has results.'
                foreach ($Computer in $Computers) {
                    Write-Verbose -Message "Username: $($Computer.LastLogonUsername)"
                    Write-Verbose -Message "Computer: $($Computer.Name)"
                    Write-Verbose -Message "LastLogonTimeStamp: $($Computer.LastLogonTimeStamp)"
                    $ComputerByLoggedOnUserProperties = [ordered]@{
                        'Username'           = $Computer.LastLogonUserName
                        'ComputerName'       = $Computer.Name
                        'LastLogonTimeStamp' = [datetime]::ParseExact($Computer.LastLogonTimeStamp.Split('.')[0],'yyyyMMddHHmmss',[System.Globalization.CultureInfo]::InvariantCulture)
                    }
                    $ComputerByLoggedOnUser = New-Object -TypeName PSCustomObject -Property $ComputerByLoggedOnUserProperties
                    $ComputerByLoggedOnUser
                }
                
            }
            else {
                Write-Verbose -Message "No computers found for user $User"
            }   
        }
    }
    end {}
}