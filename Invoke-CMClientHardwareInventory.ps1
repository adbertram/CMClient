#region Invoke-CMClientHardwareInventory
<#
.SYNOPSIS
	This function invokes a hardware inventory cycle on a ConfigMgr client
.DESCRIPTION

.PARAMETER  Computername
	The name of the system you'd like to invoke the action on
.PARAMETER  AsJob
	Specify this parameter if you'd like to run this as a background job.
.EXAMPLE
	PS C:\> Invoke-CMClientHardwareInventory -Computername 'Value1' -AsJob
.NOTES

#>
function Invoke-CMClientHardwareInventory {
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
			    'ClientAction' = 'HardwareInventory';
			    'AsJob' = $AsJob.IsPresent
		    }
		    Invoke-CMClientAction @Params
            }
	}
	End {
		
	}
}
#endregion