#region Invoke-CMClientMachinePolicyDownload
<#
.SYNOPSIS
	This function invokes a machine policy download on a ConfigMgr client
.DESCRIPTION

.PARAMETER  Computername
	The name of the system you'd like to invoke the machine policy download on
.PARAMETER  AsJob
	Specify this parameter if you'd like to run this as a background job.
.EXAMPLE
	PS C:\> Invoke-CMClientMachinePolicyDownload -Computername 'Value1' -AsJob
.NOTES

#>
function Invoke-CMClientMachinePolicyDownload {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true)]
		[alias('Name')]
		[string[]]$Computername,
		[Parameter()]
		[switch]$AsJob
	)
	
	Begin {
		
	}
	Process {
		foreach ($Computer in $Computername) {
            $Params = @{
			    'Computername'	= $Computer;
			    'ClientAction'  = 'MachinePolicy';
			    'AsJob'			= $AsJob.IsPresent
		        }
		    Invoke-CMClientAction @Params
            }
	}
	End {
		
	}
}
#endregion