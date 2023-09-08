Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name "PnP.PowerShell" -RequiredVersion 1.12.0
Import-Module PnP.PowerShell
Write-Output "PnP.PowerShell Imported ... OK"

$pfxFileName = '.\MEAFUSION.pfx'
$bytes = [Convert]::FromBase64String($Env:MEAFUSION_PFX)
[IO.File]::WriteAllBytes($pfxFileName, $bytes)
Write-Output "PFX file generated ... OK"

Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath $pfxFileName -CertificatePassword (ConvertTo-SecureString -AsPlainText $Env:MEAFUSION_PFX_PASSWORD -Force) -Url https://meafusion.sharepoint.com/sites/DEV -Tenant "meafusion.onmicrosoft.com" 
Write-Output "Connect to the Source Site ... OK"

$jsonData = Get-Content -Path ".\SharePoint\lists.json" -Raw | ConvertFrom-Json
foreach ($current_property in $jsonData.PSObject.Properties) {
    Write-Host "$($current_property.Name): $($current_property.Value)"
}
Get-PnPSiteTemplate -Out "TemplateFile.xml" -ListsToExtract "Gift ideas" -Handlers Lists
Write-Output "Create the Template ... OK"

Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath $pfxFileName -CertificatePassword (ConvertTo-SecureString -AsPlainText $Env:MEAFUSION_PFX_PASSWORD -Force) -Url https://meafusion.sharepoint.com/sites/UAT -Tenant "meafusion.onmicrosoft.com" 
Write-Output "Connect to Target Site ... OK"

Invoke-PnPSiteTemplate -Path "TemplateFile.xml"
Write-Output "Apply the Template ... OK"
