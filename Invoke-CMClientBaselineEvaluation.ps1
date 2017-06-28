<#
.Synopsis
   Initiate the evaluation of Configuration Manager client configuration baselines.

.DESCRIPTION
   Initiate the evaluation of Configuration Manager client configuration baselines.

.NOTES
   Created by: Jason Wasser @wasserja
   Modified: 5/17/2017 04:09:20 PM 

.EXAMPLE
Invoke-CMClientBaselineEvaluation

__GENUS          : 1
__CLASS          : __PARAMETERS
__SUPERCLASS     : 
__DYNASTY        : __PARAMETERS
__RELPATH        : __PARAMETERS
__PROPERTY_COUNT : 2
__DERIVATION     : {}
__SERVER         : SERVER01
__NAMESPACE      : ROOT\ccm\dcm
__PATH           : \\SERVER01\ROOT\ccm\dcm:__PARAMETERS
JobId            : {70CC8CE2-1349-4B2A-9D6C-030DE174D269}
ReturnValue      : 0
PSComputerName   : SERVER01

.EXAMPLE
Invoke-CMClientBaselineEvaluation -ComputerName SERVER01,SERVER02

__GENUS          : 1
__CLASS          : __PARAMETERS
__SUPERCLASS     : 
__DYNASTY        : __PARAMETERS
__RELPATH        : __PARAMETERS
__PROPERTY_COUNT : 2
__DERIVATION     : {}
__SERVER         : SERVER01
__NAMESPACE      : ROOT\ccm\dcm
__PATH           : \\SERVER01\ROOT\ccm\dcm:__PARAMETERS
JobId            : {70CC8CE2-1349-4B2A-9D6C-030DE174D269}
ReturnValue      : 0
PSComputerName   : SERVER01

__GENUS          : 1
__CLASS          : __PARAMETERS
__SUPERCLASS     : 
__DYNASTY        : __PARAMETERS
__RELPATH        : __PARAMETERS
__PROPERTY_COUNT : 2
__DERIVATION     : {}
__SERVER         : SERVER02
__NAMESPACE      : ROOT\ccm\dcm
__PATH           : \\SERVER02\ROOT\ccm\dcm:__PARAMETERS
JobId            : {1D92D42D-B1B4-4256-B8AE-24F7CC382578}
ReturnValue      : 0
PSComputerName   : SERVER02

#>
function Invoke-CMClientBaselineEvaluation {
    [CmdletBinding()]
    param (        
        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [string[]]$ComputerName = $env:COMPUTERNAME
    )
    begin {}
    process {
        foreach ($Computer in $ComputerName) {
            # Get a list of baseline objects assigned to the remote computer
            Write-Verbose -Message "Attempting to get Configuration Baselines for $Computer"
            $Baselines = Get-WmiObject -ComputerName $Computer -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration

            # For each (%) baseline object, call SMS_DesiredConfiguration.TriggerEvaluation, passing in the Name and Version as params
            foreach ($Baseline in $Baselines) {
                Write-Verbose -Message "Triggering configuration baseline evaluation $($Baseline.DisplayName) on $Computer"
                ([wmiclass]"\\$Computer\root\ccm\dcm:SMS_DesiredConfiguration").TriggerEvaluation($Baseline.Name, $Baseline.Version) 
            }
        }
    }
    end {}
    
}