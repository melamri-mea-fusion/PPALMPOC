
Get-Module -Name PnP.PowerShell -ListAvailable | Select Path
Import-Module PnP.PowerShell
Write-Output "PnP.PowerShell Imported ... OK"

$pfxFileName = '.\MEAFUSION.pfx'
$bytes = [Convert]::FromBase64String($Env:MEAFUSION_PFX)
[IO.File]::WriteAllBytes($pfxFileName, $bytes)
Write-Output "PFX file generated ... OK"

$listsToMigrate = Get-Content -Path ".\SharePoint\lists.json" -Raw | ConvertFrom-Json
foreach ($list in $listsToMigrate) {
    Write-Output "$list migration job starting ..."

    Connect-PnPOnline -ClientId '9afea424-5d73-428b-b9ea-e0d87d400831' -CertificatePath $pfxFileName -CertificatePassword (ConvertTo-SecureString -AsPlainText $Env:MEAFUSION_PFX_PASSWORD -Force) -Url $Env:SHAREPOINT_SOURCE_SITE -Tenant "meafusion.onmicrosoft.com" 
    Write-Output "Connect to the Source Site ... OK"
    $templateFileName = ($list -replace " ","") +"TemplateFile.xml"
    Get-PnPSiteTemplate -Out .\SharePoint\schema\$list+"TemplateFile.xml" -ListsToExtract $list -Handlers Lists
    Write-Output "Create the Template for $list ... OK" 
}
$guid = [System.Guid]::NewGuid()
$guidString = $guid.ToString("D")
$branchName = "sharepoint-patch-" +  $guid

git checkout -b $branchName
git config user.name github-actions
git config user.email github-actions@github.com
git add .\SharePoint\schema\*
git commit -m "generated"
git push -u origin $branchName

