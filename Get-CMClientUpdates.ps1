#region Get-CMClientUpdates
<#
.SYNOPSIS
	This function gets a list of software updates for a SCCM client.
.DESCRIPTION

.PARAMETER  Computername
	The name of the system you'd like to invoke the action on
.EXAMPLE
	PS C:\> Get-CMClientUpdates -Computername 'SERVER01'
.EXAMPLE
    PS C:\> Get-CMClientUpdates -Computername 'SERVER01' -Summary
.NOTES

#>
function Get-CMClientUpdates {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [switch]$Summary
        )

    begin {}
    process {

        foreach ($Computer in $ComputerName) {
            if ($Computer -eq $env:COMPUTERNAME) {
                $SccmUpdates = Get-WmiObject -Namespace root\ccm\SoftwareUpdates\UpdatesStore -Class CCM_UpdateStatus
                }
            else {
                $SccmUpdates = Get-WmiObject -Namespace root\ccm\SoftwareUpdates\UpdatesStore -Class CCM_UpdateStatus -ComputerName $Computer
                }
            if ($Summary) {
                $SccmUpdates | Select-Object -Property PSComputerName,Article,@{label=’ScanTime’;expression={$_.ConvertToDateTime($_.ScanTime)}},Status,Title
                }
            else {
                $SccmUpdates
                }
            }
        }
    end {}
    }
#endregion
