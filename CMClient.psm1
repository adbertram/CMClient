<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.58
	 Created on:   	6/9/2014 1:57 PM
	 Created by:   	Adam Bertram
	 Filename:     	CMClient.psm1
     Modified:      8/17/2015 03:02:23 PM 
     Modified by:   Jason Wasser @wasserja
	-------------------------------------------------------------------------
	 Module Name: CMClient
	===========================================================================
#>


# Source all ps1 files from module directory.
# https://becomelotr.wordpress.com/2017/02/13/expensive-dot-sourcing/
foreach ($file in Get-ChildItem $PSScriptRoot\*.ps1) {
    $ExecutionContext.InvokeCommand.InvokeScript(
        $false, 
        (
            [scriptblock]::Create(
                [io.file]::ReadAllText(
                    $file.FullName,
                    [Text.Encoding]::UTF8
                )
            )
        ), 
        $null, 
        $null
    )
}