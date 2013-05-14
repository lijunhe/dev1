#
### Configure SharePoint 2013 for server-to-server app use and configure trust for your app
#

#
# 1. Add certificate to SharePoint’s list of trusted root certificate authorities
#

# a. Get the .cer file that you want to use with your app
$publicCertPath = "C:\Development\Certificates\App4SP2013DevCert.cer"

# f. Get the file that corresponds to the .cer file you’re using for the app
$certificate = Get-PfxCertificate $publicCertPath

# g. Add the certificate to SharePoint’s list of trusted root certificate authorities
##New-SPTrustedRootAuthority -Name "unique name for the certificate" -Certificate $certificate
New-SPTrustedRootAuthority -Name "App for SharePoint Dev Cert - Lijun" -Certificate $certificate

#
# 2. Create trusted security token service on SharePoint Target Site
#

# b. Get the issuer ID of your app. Currently, all the letters in the issuer ID GUID must be lowercase
$issuerId = "b8ce7077-9d2c-4cd0-903e-b8882cb48f86"

# c. Get the SharePoint 2013 URL where you will be installing your app
##$spurl ="http://ContosoSharePoint.com"
$spurl ="http://lhw2k8r2s1/sites/dev2"

# d. Get the website where you are installing your app
### If you're doing remote development where Visual Studio 2012 and SharePoint 2013 are not installed on 
### the same computer, the root site collection must be created from a Developer Site template. It's required. 
### If Visual Studio 2012 and SharePoint 2013 are installed on the same computer, it isn’t required.)
$spweb = Get-SPWeb $spurl

# e. Get the current authentication realm for your SharePoint site
$realm = Get-SPAuthenticationRealm -ServiceContext $spweb.Site

# h. Get the issuer ID together with the realm value
$fullIssuerIdentifier = $issuerId + '@' + $realm

# a. Get the .cer file that you want to use with your app
$publicCertPath = "C:\Development\Certificates\App4SP2013DevCert.cer"

# f. Get the file that corresponds to the .cer file you’re using for the app
$certificate = Get-PfxCertificate $publicCertPath

# i. Create a trusted security token service. 
#	 This fetches metadata from your app (for example, the certificate) and establishes trust with it, 
#	 so that SharePoint 2013 can accept tokens that are issued by your app
New-SPTrustedSecurityTokenIssuer -Name $issuerId -Certificate $certificate -RegisteredIssuerName $fullIssuerIdentifier –IsTrustBroker

# j. Run the iisreset command to make your new issuer ID valid. 
#	 The issuer ID will become valid after 24 hours if you do not run iisreset.
