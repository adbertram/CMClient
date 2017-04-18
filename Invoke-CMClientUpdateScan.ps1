#region Invoke-CMClientUpdateScan
<#
.SYNOPSIS
	This function invokes an update scan eval on a ConfigMgr client
.DESCRIPTION

.PARAMETER  Computername
	The name of the system you'd like to invoke the action on
.PARAMETER  AsJob
	Specify this parameter if you'd like to run this as a background job.
.EXAMPLE
	PS C:\> Invoke-CMClientUpdateScan -Computername 'Value1' -AsJob
.NOTES

#>
function Invoke-CMClientUpdateScan {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[string[]]$Computername,
		[Parameter()]
		[switch]$AsJob
	)
	
	Begin {
		
	}
	Process {
		foreach ($Computer in $Computername) {
            $Params = @{
			    'Computername' = $Computer;
			    'ClientAction' = 'UpdateScan';
			    'AsJob' = $AsJob.IsPresent
		    }
		    Invoke-CMClientAction @Params
            }
	}
	End {
		
	}
}
#endregion