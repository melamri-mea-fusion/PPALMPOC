Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name "PnP.PowerShell"
Import-Module PnP.PowerShell
#Connect to the Source Site
Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath ".\MEAFUSION.pfx" -CertificatePassword (ConvertTo-SecureString -AsPlainText "smysmy9393@@" -Force) -Url https://meafusion.sharepoint.com/sites/DEV -Tenant "meafusion.onmicrosoft.com" 
#Create the Template
Get-PnPSiteTemplate -Out "TemplateFile.pnp" -ListsToExtract "Gift ideas" -Handlers Lists
  
#Connect to Target Site
Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath "C:\Users\PC\Desktop\SP PoC\MEAFUSION.pfx" -CertificatePassword (ConvertTo-SecureString -AsPlainText "smysmy9393@@" -Force) -Url https://meafusion.sharepoint.com/sites/UAT -Tenant "meafusion.onmicrosoft.com" 
 
#Apply the Template
Invoke-PnPSiteTemplate -Path "TemplateFile.pnp"
