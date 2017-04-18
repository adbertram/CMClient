#region Initialize-CMClientJob
<#
.SYNOPSIS
	This is a helper function that starts and manages background jobs for the all
	functions in this module.
.DESCRIPTION

.PARAMETER  OriginatingFunction
	The function where the job request came from.  This is used to keep track of
	which background jobs were started by which function.
.PARAMETER  ScriptBlock
	This is the scriptblock that is passed to the system.
.PARAMETER  Computername
	The computer name that the function is connecting to.  This is used to keep track
	of the functions initiated on computers.
.PARAMETER  ScheduleID
	This is the schedule ID to designate which client action to initiate.  This is needed
	because it has to be sent to the background job scriptblock.
.EXAMPLE

.NOTES
#>
function Initialize-CMClientJob {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$OriginatingFunction,
		[Parameter(Mandatory = $true)]
		[scriptblock]$ScriptBlock,
		[Parameter(Mandatory = $true)]
		[string]$Computername,
		[Parameter(Mandatory = $true)]
		[string]$ScheduleID
	)
	
	Begin {
		## The total number of jobs that can be concurrently running
		$MaxJobThreads = 75
		## How long to wait when the max job threads has been met to start another job
		$JobWaitSecs = 1
	}
	Process {
		try {
			Write-Verbose "Starting job `"$ComputerName - $OriginatingFunction`"..."
			Start-Job -ScriptBlock $ScriptBlock -Name "$ComputerName - $OriginatingFunction" -ArgumentList $Computername, $ScheduleID | Out-Null
			While ((Get-Job -state running).count -ge $MaxJobThreads) {
				Write-Verbose "Maximum job threshold has been met.  Waiting $JobWaitSecs second(s) to try again...";
				Start-Sleep -Seconds $JobWaitSecs
			}			
		} catch {
			Write-Error $_.Exception.Message
		}
	}
	End {
		
	}
}
#endregion