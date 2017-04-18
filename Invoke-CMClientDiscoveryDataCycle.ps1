#region Invoke-CMClientDiscoveryDataCycle
<#
.SYNOPSIS
	This function invokes a DDR cycle on a ConfigMgr client
.DESCRIPTION

.PARAMETER  Computername
	The name of the system you'd like to invoke the action on
.PARAMETER  AsJob
	Specify this parameter if you'd like to run this as a background job.
.EXAMPLE
	PS C:\> Invoke-CMClientDiscoveryDataCycle -Computername 'Value1' -AsJob
.NOTES

#>
function Invoke-CMClientDiscoveryDataCycle {
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
			    'ClientAction' = 'DiscoveryData';
			    'AsJob' = $AsJob.IsPresent
		        }
		        Invoke-CMClientAction @Params
            }
	}
	End {
		
	}
}
#endregion