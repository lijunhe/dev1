# 0. http://msdn.microsoft.com/en-us/library/fp179923(v=office.15).aspx

# 1. Ensure that the spadmin and sptimer services are running
net start spadminv4
net start sptimerv4

# 2. create isolated app domain

# 3. Ensure that the SPSubscriptionSettingsService and AppManagementServiceInstance services are running
Get-SPServiceInstance | where{$_.GetType().Name -eq "AppManagementServiceInstance" -or $_.GetType().Name -eq "SPSubscriptionSettingsServiceInstance"} | Start-SPServiceInstance

# 4. Verify that the SPSubscriptionSettingsService and AppManagementServiceInstance services are running
Get-SPServiceInstance | where{$_.GetType().Name -eq "AppManagementServiceInstance" -or $_.GetType().Name -eq "SPSubscriptionSettingsServiceInstance"}

# 5. create an SPManagedAccount under which the SPSubscriptionService and AppManagementServiceInstance service instances will run
#$account = New-SPManagedAccount
$userName = "lhdev\sp2013apps"
if(Get-SPManagedAccount | Where-Object { $_.UserName -eq $userName }){
  # Managed Account Already exists
  Write-Host “Managed Account: $userName exists”
} else {
  # Get User Credentials
  $credential = Get-Credential -Credential $userName
  # Create New Managed Account
  New-SPManagedAccount -Credential $credential
}

# 6.1 Specify an account, application pool, and database settings for the SPSubscriptionService service
$userName = "lhdev\sp2013apps"
$account = Get-SPManagedAccount $userName
$appPoolSubSvc = New-SPServiceApplicationPool -Name SettingsServiceAppPool -Account $account
$appSubSvc = New-SPSubscriptionSettingsServiceApplication –ApplicationPool $appPoolSubSvc –Name SettingsServiceApp –DatabaseName SettingsServiceDB 
$proxySubSvc = New-SPSubscriptionSettingsServiceApplicationProxy –ServiceApplication $appSubSvc

# 6.2 Specify an account, application pool, and database settings for the AppManagementServiceInstance service
$userName = "lhdev\sp2013apps"
$account = Get-SPManagedAccount $userName
$appPoolAppSvc = New-SPServiceApplicationPool -Name AppServiceAppPool -Account $account
$appAppSvc = New-SPAppManagementServiceApplication -ApplicationPool $appPoolAppSvc -Name AppServiceApp -DatabaseName AppServiceDB
$proxyAppSvc = New-SPAppManagementServiceApplicationProxy -ServiceApplication $appAppSvc

# 2. create isolated app domain
# 7. Specify tenant name
Set-SPAppDomain lhdev.local
Set-SPAppSiteSubscriptionName -Name "app" -Confirm:$false