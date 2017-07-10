<#
.SYNOPSIS
Get the cache content on SCCM clients.

.DESCRIPTION
Get the cache content on SCCM clients using the COM object.

.PARAMETER ComputerName
Enter a computer name

.PARAMETER CacheAgeinDays
Enter a number in days of the last time cache was referenced.

.EXAMPLE
Get-CMClientCache -ComputerName DESKTOP01

Gets all SCCM client cache content

.EXAMPLE 
Get-CMClientCache -ComputerName DESKTOP01,DESKETOP01 -CacheAgeinDays 30

Gets all SCCM client cache content that hasn't been referenced in 30 days.
.NOTES
General notes
#> 
#requires -RunAsAdministrator
function Get-CMClientCache {
    [CmdletBinding()]
    param (
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [int]$CacheAgeinDays = 0        
    )
    
    begin {
        function Get-ClientCache {
            param (
                [int]$CacheAgeinDays,
                [bool]$WhatIf
            )
            $VerbosePreference = 'Continue'
            Write-Verbose "Beginning gathering of SCCM Cache older than $CacheAgeinDays days"
            $UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
            $Cache = $UIResourceMgr.GetCacheInfo()
            $CacheElements = $Cache.GetCacheElements() | Where-Object -FilterScript {$_.LastReferenceTime -lt (Get-Date).AddDays( - $CacheAgeInDays)}
            if ($CacheElements) {
                if ($CacheElements.Count) {
                    Write-Verbose -Message "Found $($CacheElements.Count) cache elements on $($env:COMPUTERNAME)."
                }
                else {
                    Write-Verbose -Message "Found a cache element on $($env:COMPUTERNAME)."
                }
                
                foreach ($Element in $CacheElements) {
                    Write-Verbose "CacheElement with PackageID $($Element.ContentID) with location $($Element.Location)"
                    Write-Output $Element
                    
                }
            }
            else {
                Write-Verbose -Message "No cache elements found on $($env:COMPUTERNAME)"
            }   
        }
    }
    
    process {

        foreach ($Computer in $ComputerName) {
            Write-Verbose -Message "Attempting to get SCCM client cache on $Computer older than $CacheAgeinDays days"
            Invoke-Command -ComputerName $Computer -ScriptBlock ${function:Get-ClientCache} -ArgumentList $CacheAgeinDays
        }
    }

    end {
    }
}