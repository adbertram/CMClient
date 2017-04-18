#region Invoke-CMClientAction
<#
.SYNOPSIS
	This is a helper function that initiates many ConfigMgr client actions.
.DESCRIPTION

.PARAMETER  Computername
	The system you'd like to initate the action on.
.PARAMETER  AsJob
	A switch parameter that initates a job in the background
.PARAMETER  ClientAction
	The client action to initiate.
.EXAMPLE
	PS C:\> Invoke-CMClientAction -Computername 'Value1' -AsJob
	This example shows how to call the Invoke-CMClientAction function with named parameters.
.NOTES
#>
function Invoke-CMClientAction {
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
		[string]$Computername,
		[Parameter(Mandatory = $true)]
		[ValidateSet('MachinePolicy',
			'DiscoveryData',
			'ComplianceEvaluation',
			'AppDeployment', 
			'HardwareInventory',
			'UpdateDeployment',
			'UpdateScan',
			'SoftwareInventory')]
		[string]$ClientAction,
		[Parameter()]
		[switch]$AsJob
	)
	
	Begin {

        try {
			$ScheduleIDMappings = @{
				'MachinePolicy' = '{00000000-0000-0000-0000-000000000021}';
				'DiscoveryData' = '{00000000-0000-0000-0000-000000000003}';
				'ComplianceEvaluation' = '{00000000-0000-0000-0000-000000000071}';
				'AppDeployment' = '{00000000-0000-0000-0000-000000000121}';
				'HardwareInventory' = '{00000000-0000-0000-0000-000000000001}';
				'UpdateDeployment' = '{00000000-0000-0000-0000-000000000108}';
				'UpdateScan' = '{00000000-0000-0000-0000-000000000113}';
				'SoftwareInventory' = '{00000000-0000-0000-0000-000000000002}';
			}
			$ScheduleID = $ScheduleIDMappings[$ClientAction]
		} catch {
			Write-Error $_.Exception.Message
		}
		
	}
	Process {
		try {
			## $args[0] represents the computername and $args[1] represents the scheduleID
            $ActionScriptBlock = {
			    [void] ([wmiclass] "\\$($args[0])\root\ccm:SMS_Client").TriggerSchedule($args[1]);
				if (!$?) {
					throw "Failed to initiate a $ClientAction on $($args[0])"
				    }
			    }
			
			if ($AsJob.IsPresent) {
                $Params = @{
					'Computername' = $Computername;
					'OriginatingFunction' = $ClientAction;
					'ScriptBlock' = $ActionScriptBlock;
					'ScheduleID' = $ScheduleID
				}
				Initialize-CMClientJob @Params
			} else {
                Write-Verbose "Initializing $ClientAction on $Computername."
				Invoke-Command -ScriptBlock $ActionScriptBlock -ArgumentList $Computername,$ScheduleID
			}
		} catch {
			Write-Error $_.Exception.Message
		}
		
	}
	End {
		
	}
}
#endregion