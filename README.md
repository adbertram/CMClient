# CMClient

Use this module to kick off many common client triggers like Machine Policy Download, Discovery Data Cycle, Compliance Evaluation, Application Deployment Evaluation, Hardware Inventory, Software Inventory, Update Deployment Evaluation and Update Scan.  

This module has something a lot of the other modules I've seen don't have which is -AsJob support.  This means you don't have to wait around on each of your clients to invoke whatever action they'r doing.  Instead, you can use the -AsJob parameter which will invoke each action as a PowerShell job so you can run lots of actions asynchronously.

<pre>
PS C:\> Get-Command -Module CMClient

CommandType Name                                           Version Source
----------- ----                                           ------- ------
Function    Get-CMClientBaselineEvaluation                 1.6.0   CMClient
Function    Get-CMClientComputerByLoggedOnUser             1.6.0   CMClient
Function    Get-CMClientDeviceCollectionMembership         1.6.0   CMClient
Function    Get-CMClientPackage                            1.6.0   CMClient
Function    Get-CMClientPendingUpdates                     1.6.0   CMClient
Function    Get-CMClientUpdates                            1.6.0   CMClient
Function    Get-CMClientVersion                            1.6.0   CMClient
Function    Invoke-CMClientApplicationDeploymentEvaluation 1.6.0   CMClient
Function    Invoke-CMClientBaselineEvaluation              1.6.0   CMClient
Function    Invoke-CMClientComplianceEvaluation            1.6.0   CMClient
Function    Invoke-CMClientDiscoveryDataCycle              1.6.0   CMClient
Function    Invoke-CMClientHardwareInventory               1.6.0   CMClient
Function    Invoke-CMClientMachinePolicyDownload           1.6.0   CMClient
Function    Invoke-CMClientUpdateDeploymentEvaluation      1.6.0   CMClient
Function    Invoke-CMClientUpdateScan                      1.6.0   CMClient
</pre>