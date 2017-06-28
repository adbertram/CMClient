<#
.SYNOPSIS
This function gets the SCCM client version.
.DESCRIPTION
This function gets the SCCM client version.
.PARAMETER Computername
Enter a name of a computer or list of computers.
.EXAMPLE
Get-CMClientVersion -Computername 'SERVER01'
.EXAMPLE
Get-CMClienVersion -Computername 'SERVER01','WORKSTATION02'
.NOTES
Created by: Jason Wasser @wasserja
#>
function Get-CMClientVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )

    begin {}
    process {

        foreach ($Computer in $ComputerName) {
            Write-Verbose -Message "Checking SCCM Client version on $Computer"
            if ($Computer -eq $env:COMPUTERNAME) {
                $SccmClientVersion = Get-WmiObject -Namespace 'ROOT\ccm' -Class Ccm_InstalledComponent -Filter "Name = 'SmsClient'"
            }
            else {
                $SccmClientVersion = Get-WmiObject -Namespace 'ROOT\ccm' -Class Ccm_InstalledComponent -Filter "Name = 'SmsClient'" -ComputerName $Computer
            }
            $SccmClientVersion | Select-Object -Property PSComputerName, Version
        }
    }
    end {}
}