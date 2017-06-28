<#
.SYNOPSIS
This function gets a list of advertised packages for a SCCM client.
.DESCRIPTION
This function gets a list of advertised packages for a SCCM client.
.PARAMETER Computername
Enter a name of a computer or list of computers.
.PARAMETER Details
Outputs the full WMI object rather than just a summary.
.EXAMPLE
PS C:\> Get-CMClientPackage -Computername 'SERVER01'
.EXAMPLE
PS C:\> Get-CMClientPackage -Computername 'SERVER01' -Details
.NOTES
Created by: Jason Wasser @wasserja
#>
function Get-CMClientPackage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName,
        [switch]$Details
        )

    begin {}
    process {

        foreach ($Computer in $ComputerName) {
            Write-Verbose -Message "Checking for advertised packages on $Computer"
            if ($Computer -eq $env:COMPUTERNAME) {
                $SccmPackages = Get-WmiObject -Namespace 'ROOT\ccm\SoftMgmtAgent' -Class CCM_ExecutionRequestEx
                }
            else {
                $SccmPackages = Get-WmiObject -Namespace 'ROOT\ccm\SoftMgmtAgent' -Class CCM_ExecutionRequestEx -ComputerName $Computer
                }
            if ($Details) {
                $SccmPackages 
                }
            else {
                $SccmPackages | Select-Object -Property PSComputerName,ProgramID,ContentID,State,@{label='ReceivedTime';expression={$_.ConvertToDateTime($_.ReceivedTime)}}
                }
            }
        }
    end {}
}
