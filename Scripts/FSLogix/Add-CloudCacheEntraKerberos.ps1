# Didn't mean to add these here but they're not publically accessible.
$connectionstrings = @{
    'cfavddevfslogix2' = 'fslogix'
    'cfavddevfslogix'= 'entrafslogix'
}

$CCDLocations = ""

# Allows as many CCD Locations as written in hashtable $connectionstrings
foreach($connectionstring in $connectionstrings.GetEnumerator()){
    $CCDLocations += "type=smb,connectionString=\\$($connectionstring.name).file.core.windows.net\$($connectionstring.value);"
}

# Removes VHDLocations. If fslogix was previously used it prevents Cloud Cache from operating. 
Clear-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name VHDLocations -Force

New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name CCDLocations -PropertyType string -value $CCDLocations -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name ClearCacheOnLogoff -PropertyType dword -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name Enabled -PropertyType dword -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name DeleteLocalProfileWhenVHDShouldApply -PropertyType dword -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name FlipFlopProfileDirectoryName -PropertyType dword -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name HealthyProvidersRequiredForRegister -PropertyType dword -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name LockedRetryCount -PropertyType dword -Value 3 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name LockedRetryInterval -PropertyType dword -Value 15 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name ProfileType -PropertyType dword -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name ReAttachRetryCount -PropertyType dword -Value 3 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name ReAttachIntervalSeconds -PropertyType dword -Value 15 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name SizeInMBs -PropertyType dword -Value 30000 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles\ -Name VolumeType -PropertyType string -Value vhdx -Force

# Enables Kerberos for Entra
reg add HKLM\Software\Policies\Microsoft\AzureADAccount /v LoadCredKeyFromProfile /t REG_DWORD /d 1
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters /v CloudKerberosTicketRetrievalEnabled /t REG_DWORD /d 1
