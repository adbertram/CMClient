<#
.Synopsis
   Get the status of Configuration Manager client configuration baselines.

.DESCRIPTION
   Get the status of Configuration Manager client configuration baselines.
.NOTES
   Created by: Jason Wasser @wasserja
   Modified: 5/17/2017 04:05:12 PM 

.EXAMPLE
Get-CMClientBaselineEvaluation

ComputerName       : SERVER01
BaselineName       : SMB1 Disabled
Version            : 2
EvaluationStatus   : Idle
Compliance         : Compliant
LastEvaluationTime : 5/17/2017 7:46:44 PM

.EXAMPLE
Get-CMClientBaselineEvaluation -ComputerName SERVER01,SERVER02

ComputerName       : SERVER01
BaselineName       : SMB1 Disabled
Version            : 2
EvaluationStatus   : Idle
Compliance         : Compliant
LastEvaluationTime : 5/17/2017 7:46:44 PM

ComputerName       : SERVER02
BaselineName       : SMB1 Disabled
Version            : 2
EvaluationStatus   : Idle
Compliance         : Compliant
LastEvaluationTime : 5/17/2017 7:46:37 PM

#>
function Get-CMClientBaselineEvaluation
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   ValueFromPipeline=$true,
                   Position=0)]
        [string[]]$ComputerName=$env:COMPUTERNAME
    )


    begin {
        $ComplianceHash = [hashtable]@{
            "0" = 'Non-Compliant'
            "1" = 'Compliant'
            "2" = 'Submitted'
            "3" = 'Unknown'
            "4" = 'Detecting'
            "5" = 'Not Evaluated'                  
        }  
        $EvalHash = [hashtable]@{
            "0"  = 'Idle'
            "1"  = 'Evaluated'
            "5"  = 'Not Evaluated'
            "99" = 'Unknown'
        } 
    
    }
    process {
        foreach ($Computer in $ComputerName) {
            # Get a list of baseline objects assigned to the remote computer
            $Baselines = Get-WmiObject -ComputerName $Computer -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration | Sort-Object DisplayName

            # For each (%) baseline object, call SMS_DesiredConfiguration.TriggerEvaluation, passing in the Name and Version as params
            foreach ($Baseline in $Baselines) {
                if ($Baseline.LastEvalTime -eq '00000000000000.000000+000') {
                    $LastEvalTime = 'N/A'
                } 
                else {
                    $LastEvalTime = $Baseline.ConvertToDateTime($Baseline.LastEvalTime)
                }


                $BaselineStatus = [pscustomobject]@{
                    ComputerName = $Baseline.PSComputerName
                    BaselineName = $Baseline.DisplayName
                    Version = $Baseline.Version
                    EvaluationStatus = if ($null -eq $Baseline.Status) { $EvalHash['99'] } else { $EvalHash[$Baseline.Status.ToString()] }
                    Compliance = $ComplianceHash[$Baseline.LastComplianceStatus.tostring()]
                    LastEvaluationTime = $LastEvalTime
                }
                
                $BaselineStatus
            }
        }
    }

    end {}
    
}
