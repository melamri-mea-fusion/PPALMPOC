$env:PNPPOWERSHELL_UPDATECHECK=false
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name "PnP.PowerShell" -RequiredVersion 1.12.0 -Force -AllowClobber
Import-Module PnP.PowerShell

$pfxFileName = '.\MEAFUSION.pfx'
$bytes = [Convert]::FromBase64String($Env:MEAFUSION_PFX)
[IO.File]::WriteAllBytes($pfxFileName, $bytes)

#Connect to the Source Site
Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath $pfxFileName -CertificatePassword (ConvertTo-SecureString -AsPlainText $Env:MEAFUSION_PFX_PASSWORD -Force) -Url https://meafusion.sharepoint.com/sites/DEV -Tenant "meafusion.onmicrosoft.com" 
#Create the Template
Get-PnPSiteTemplate -Out "TemplateFile.pnp" -ListsToExtract "Gift ideas" -Handlers Lists
  
#Connect to Target Site
Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath $pfxFileName -CertificatePassword (ConvertTo-SecureString -AsPlainText $Env:MEAFUSION_PFX_PASSWORD -Force) -Url https://meafusion.sharepoint.com/sites/UAT -Tenant "meafusion.onmicrosoft.com" 
 
#Apply the Template
Invoke-PnPSiteTemplate -Path "TemplateFile.pnp"
