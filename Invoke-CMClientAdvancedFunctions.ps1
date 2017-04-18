## Modify these function as advanced functions
<#
Function Set-CMClientBusinessHours ($ComputerName, $StartTime = 3, $EndTime = 7, $WorkingDays) {
	## The first digit is the start time (7am), the second digit is the end time (7pm) and the third digit is the days of the week.
	## The days of the week are calculated using the table below, so Monday – Friday is calculated as 2+4+8+16+32 = 62.
	## Sunday - 1, Monday - 2, Tuesday - 4, Wednesday - 8, Thursday - 16, Friday - 32, Saturday - 64
	
	try {
		Write-Debug "Initiating the $($MyInvocation.MyCommand.Name) function...";
		
		$cmClientUserSettings = [WmiClass]"\\$ComputerName\ROOT\ccm\ClientSDK:CCM_ClientUXSettings"
		$businessHours = $cmClientUserSettings.PSBase.GetMethodParameters("SetBusinessHours")
		$businessHours.StartTime = $StartTime
		$businessHours.EndTime = $EndTime
		$businessHours.WorkingDays = $WorkingDays
		
		$result = $cmClientUserSettings.PSBase.InvokeMethod("SetBusinessHours", $businessHours, $Null)
		
		if ($result.ReturnValue -eq 0) {
			$mResult = $true
		} else {
			$mResult = $false;
		}
		
		return $mResult
		
	} catch [System.Exception] {
		Write-Error $_.Exception.Message;
	}##endtry
}##endfunction

Function Get-CMClientBusinessHours ($ComputerName) {
	## The first digit is the start time (7am), the second digit is the end time (7pm) and the third digit is the days of the week.
	## The days of the week are calculated using the table below, so Monday – Friday is calculated as 2+4+8+16+32 = 62.
	## Sunday - 1, Monday - 2, Tuesday - 4, Wednesday - 8, Thursday - 16, Friday - 32, Saturday - 64
	
	try {
		Write-Debug "Initiating the $($MyInvocation.MyCommand.Name) function...";
		
		$cmClientUserSettings = [WmiClass]"\\$ComputerName\ROOT\ccm\ClientSDK:CCM_ClientUXSettings"
		$businessHours = $cmClientUserSettings.GetBusinessHours()
		$businessHoursCI = [string]$businessHours.StartTime + "," + [string]$businessHours.EndTime + "," + [string]$businessHours.WorkingDays
		
		return $businessHoursCI
		
	} catch [System.Exception] {
		Write-Error $_.Exception.Message;
	}##endtry
}##endfunction

Function Disable-CMClientBusinessHours ($ComputerName) {
	try {
		## Change the "automatic install or uninstall required software and restart the computer only outside of the specified business hours
		
		return $mResult
		
	} catch [System.Exception] {
		Write-Error $_.Exception.Message;
	}##endtry
}##endfunction

Function Get-SccmApplicationState ($ComputerName,$Name = $null,[switch]$IncludeDetails) {
	try {
		Write-Debug "Initiating the $($MyInvocation.MyCommand.Name) function...";
        
        $eval_states = @{0 = 'No state information is available';
                        1 = 'Application is enforced to desired/resolved state';
                        2 = 'Application is not required on the client';
                        3 = 'Application is available for enforcement (install or uninstall based on resolved state). Content may/may not have been downloaded';
                        4 = 'Application last failed to enforce (install/uninstall)';
                        5 = 'Application is currently waiting for content download to complete';
                        6 = 'Application is currently waiting for content download to complete';
                        7 = 'Application is currently waiting for its dependencies to download';
                        8 = 'Application is currently waiting for a service (maintenance) window';
                        9 = 'Application is currently waiting for a previously pending reboot';
                        10 = 'Application is currently waiting for serialized enforcement';
                        11 = 'Application is currently enforcing dependencies';
                        12 = 'Application is currently enforcing';
                        13 = 'Application install/uninstall enforced and soft reboot is pending';
                        14 = 'Application installed/uninstalled and hard reboot is pending';
                        15  = 'Update is available but pending installation';
                        16 = 'Application failed to evaluate';
                        17 = 'Application is currently waiting for an active user session to enforce';
                        18 = 'Application is currently waiting for all users to logoff';
                        19 = 'Application is currently waiting for a user logon';
                        20 = 'Application in progress, waiting for retry';
                        21 = 'Application is waiting for presentation mode to be switched off';
                        22 = 'Application is pre-downloading content (downloading outside of install job)';
                        23 = 'Application is pre-downloading dependent content (downloading outside of install job)';
                        24 = 'Application download failed (downloading during install job)';
                        25 = 'Application pre-downloading failed (downloading outside of install job)';
                        26 = 'Download success (downloading during install job)';
                        27 = 'Post-enforce evaluation';
                        28 = 'Waiting for network connectivity';
                    }

        if ($Name -and $IncludeDetails.IsPresent) {
            $aApps = Request-Wmi -ComputerName $ComputerName -Namespace 'root\ccm\clientsdk' -Query "SELECT * FROM CCM_Application WHERE FullName = '$Name'"
        } elseif ($Name -and !$IncludeDetails.IsPresent) {
            $aApps = Request-Wmi -ComputerName $ComputerName -Namespace 'root\ccm\clientsdk' -Query "SELECT * FROM CCM_Application WHERE FullName = '$Name'" | Select-Object PSComputerName,FullName,InstallState,ErrorCode,EvaluationState,@{label='StartTime';expression={$_.ConvertToDateTime($_.StartTime)}}
        } elseif (!$Name -and $IncludeDetails.IsPresent) {
            $aApps = Request-Wmi -ComputerName $ComputerName -Namespace 'root\ccm\clientsdk' -Query "SELECT * FROM CCM_Application"
        } elseif (!$Name -and !$IncludeDetails.IsPresent) {
            $aApps = Request-Wmi -ComputerName $ComputerName -Namespace 'root\ccm\clientsdk' -Query "SELECT * FROM CCM_Application" | Select-Object PSComputerName,FullName,InstallState,ErrorCode,EvaluationState,@{label='StartTime';expression={$_.ConvertToDateTime($_.StartTime)}}
        }
		
        if (!$aApps) {
			$mResult = "$($MyInvocation.MyCommand.Name): WMI query failed";
		} else {
			$mResult = $aApps | Sort-Object FullName;
		}##endif
		
		return $mResult;
		
	} catch [System.Exception] {
		Write-Error $_.Exception.Message;
	}##endtry
}##endfunction

Function Get-CMClientUpdateDeploymentState() {

}
#>