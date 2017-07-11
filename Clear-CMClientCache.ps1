<#
.SYNOPSIS
Clear the cache content on SCCM clients.

.DESCRIPTION
Clear the cache content on SCCM clients using the COM object.

.PARAMETER ComputerName
Enter a computer name

.PARAMETER CacheAgeinDays
Enter a number in days of the last time cache was referenced.

.PARAMETER Force
Clears persisted cache items.

.EXAMPLE
Clear-CMClientCache -ComputerName DESKTOP01

Clears all SCCM client non-persistent cache content

.EXAMPLE 
Clear-CMClientCache -ComputerName DESKTOP01,DESKETOP01 -CacheAgeinDays 30 -Force

Clears all SCCM client cache content that hasn't been referenced in 30 days including persistent cache items.
.NOTES
Created by: Jason Wasser @wasserja
Modified: 7/11/2017 11:43:18 AM 
#> 
function Clear-CMClientCache {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [int]$CacheAgeinDays = 0,
        [switch]$Force    
    )
    
    begin {
        function Clean-ClientCache {
            param (
                [int]$CacheAgeinDays,
                [bool]$WhatIf,
                [bool]$Force
            )
            $VerbosePreference = 'Continue'
            Write-Verbose "Beginning clearing of SCCM Cache older than $CacheAgeinDays days"
            $UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
            $Cache = $UIResourceMgr.GetCacheInfo()
            $CacheElements = $Cache.GetCacheElements() | Where-Object -FilterScript {$_.LastReferenceTime -lt (Get-Date).AddDays( - $CacheAgeInDays)}
            if ($CacheElements) {
                if ($CacheElements.Count) {
                    Write-Verbose -Message "Found $($CacheElements.Count) cache elements on $($env:COMPUTERNAME) continuing to clear the elements in the cache."
                }
                else {
                    Write-Verbose -Message "Found a cache element on $($env:COMPUTERNAME) continuing to clear the elements in the cache."
                }
                
                foreach ($Element in $CacheElements) {
                    if ($WhatIf) {
                        if ($Force) {
                            Write-Verbose "What if: Forcing deletion of CacheElement with PackageID $($Element.ContentID) from $($Element.Location)"
                        }
                        else {
                            Write-Verbose "What if: Deleting CacheElement with PackageID $($Element.ContentID) from $($Element.Location)"
                        }
                        
                    }
                    else {
                        if ($Force) {
                            Write-Verbose "Forcing deletion of CacheElement with PackageID $($Element.ContentID) from $($Element.Location)"
                            $Cache.DeleteCacheElementEx($Element.CacheElementID, $true)
                        }
                        else {
                            Write-Verbose "Deleting CacheElement with PackageID $($Element.ContentID) from $($Element.Location)"
                            $Cache.DeleteCacheElement($Element.CacheElementID)
                        }
                        
                    }
                }
            }
            else {
                Write-Verbose -Message "No cache elements found on $($env:COMPUTERNAME)"
            }   
        }
    }
    
    process {

        foreach ($Computer in $ComputerName) {
            Write-Verbose -Message "Attempting to clear SCCM client cache on $Computer older than $CacheAgeinDays days"
            if ($PSBoundParameters.ContainsKey('WhatIf')) {
                Write-Verbose 'WhatIf detected'
                $WhatIf = $true
                if ($Force) {
                    Write-Verbose 'Force detected'
                    $Force = $true
                    Invoke-Command -ComputerName $Computer -ScriptBlock ${function:Clean-ClientCache} -ArgumentList $CacheAgeinDays, $WhatIf, $Force
                }
                else {
                    Invoke-Command -ComputerName $Computer -ScriptBlock ${function:Clean-ClientCache} -ArgumentList $CacheAgeinDays, $WhatIf
                }
                
            }
            else {
                Write-Verbose 'WhatIf not detected'
                $WhatIf = $false
                if ($Force) {
                    Write-Verbose -Message 'Force detected'
                    $Force = $true
                    Invoke-Command -ComputerName $Computer -ScriptBlock ${function:Clean-ClientCache} -ArgumentList $CacheAgeinDays, $WhatIf, $Force
                }
                else {
                    Invoke-Command -ComputerName $Computer -ScriptBlock ${function:Clean-ClientCache} -ArgumentList $CacheAgeinDays
                }
                
            }
        }
    }

    end {
    }
}