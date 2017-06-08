<#
.SYNOPSIS
Get the collection membership of a configuration manager client device or computer.

.DESCRIPTION
Get the collection membership of a configuration manager client device or computer.
This function will query System Center Configuration manager for a given computer name
and return the collections for which it is a member.

.PARAMETER ComputerName
Provide a computer name.

.PARAMETER SiteServer
Specify the name or FQDN of your SCCM site server. By default it gathers the site server
from the computer from which the function is called.

.PARAMETER SiteCode
Specify the site code of your SCCM environment. By default it gathers the site code
from the computer from which the function is called.

.PARAMETER Credential
Provide a credential object for accessing the site server.

.EXAMPLE
Get-CMClientDeviceCollectionMembership 

Gets the collection membership of the local host.

.EXAMPLE
Get-CMClientDeviceCollectionMembership -Computer DESKTOP01

Gets the collection membership of DESKTOP01

.EXAMPLE
Get-CMClientDeviceCollectionMembership -Computer DESKTOP01 -Summary

Gets the collection membership of DESKTOP01 in a summary format.

.NOTES
Created by: Jason Wasser @wasserja
Modified: 6/8/2017 10:49:50 AM 
#>
function Get-CMClientDeviceCollectionMembership {
    [CmdletBinding()]
    param (
        [string]$ComputerName = $env:COMPUTERNAME,
        [string]$SiteServer = (Get-WmiObject -Namespace root\ccm -ClassName SMS_Authority).CurrentManagementPoint,
        [string]$SiteCode = (Get-WmiObject -Namespace root\ccm -ClassName SMS_Authority).Name.Split(':')[1],
        [switch]$Summary,
        [System.Management.Automation.PSCredential]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

begin {}
process {
    Write-Verbose -Message "Gathering collection membership of $ComputerName from Site Server $SiteServer using Site Code $SiteCode."
    $Collections = Get-WmiObject -ComputerName $SiteServer -Namespace root/SMS/site_$SiteCode -Credential $Credential -Query "SELECT SMS_Collection.* FROM SMS_FullCollectionMembership, SMS_Collection where name = '$ComputerName' and SMS_FullCollectionMembership.CollectionID = SMS_Collection.CollectionID"
    if ($Summary) {
        $Collections | Select-Object -Property Name,CollectionID
    }
    else {
        $Collections    
    }
    
}
end {}
}