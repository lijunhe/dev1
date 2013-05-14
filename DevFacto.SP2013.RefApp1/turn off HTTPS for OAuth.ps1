#
# Turn off the HTTPS requirement for OAuth during development
#
### OAuth now requires SharePoint to run HTTPS, not only for your service but also for 
### SharePoint 2013. You’ll get a 403 (forbidden) message when attempting to make a call 
### to SharePoint by using a test certificate.

# Turn Off
$serviceConfig = Get-SPSecurityTokenServiceConfig
$serviceConfig.AllowOAuthOverHttp = $true
$serviceConfig.Update()

# Turn On
$serviceConfig = Get-SPSecurityTokenServiceConfig
$serviceConfig.AllowOAuthOverHttp = $false
$serviceConfig.Update()