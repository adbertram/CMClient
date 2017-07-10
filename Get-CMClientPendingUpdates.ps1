#region Get-CMClientPendingUpdates
<#
.SYNOPSIS
	This function gets a list of pending software updates for a SCCM client.
.DESCRIPTION

.PARAMETER  Computername
	The name of the system you'd like to invoke the action on
.EXAMPLE
	PS C:\> Get-CMClientPendingUpdates -Computername 'SERVER01'
.EXAMPLE
    PS C:\> Get-CMClientPendingUpdates -Computername 'SERVER01' -Summary
.NOTES

#>
function Get-CMClientPendingUpdates {
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
            Write-Verbose -Message "Checking for pending updates on $Computer"
            if ($Computer -eq $env:COMPUTERNAME) {
                $SccmPendingUpdates = Get-WmiObject -Namespace root\ccm\clientsdk -Class CCM_SoftwareUpdate
                }
            else {
                $SccmPendingUpdates = Get-WmiObject -Namespace root\ccm\clientsdk -Class CCM_SoftwareUpdate -ComputerName $Computer
                }
            if ($Summary) {
                $SccmPendingUpdates | Select-Object -Property PSComputerName,ArticleID,@{label=’Deadline’;expression={$_.ConvertToDateTime($_.Deadline)}},Name
                }
            else {
                $SccmPendingUpdates
                }
            }
        }
    end {}
}
#endregion
