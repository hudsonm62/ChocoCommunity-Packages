# WMF 3/4 only
if ($PSVersionTable.PSVersion -lt $(New-Object System.Version("5.0.0.0"))) {
    choco install dotnet4.5.1 -y
    choco upgrade powershell-packagemanagement --ignore-dependencies -y
}

$refreshenv = Get-Command refreshenv -ea SilentlyContinue
if ($null -ne $refreshenv -and $refreshenv.CommandType -ne 'Application') {
    refreshenv # You need the Chocolatey profile installed for this to work properly (Choco v0.9.10.0+).
}
else {
    Write-Warning "You need the Chocolatey profile installed for this to work properly (Choco v0.9.10.0+)"
    $v = choco -v
    if ($v -gt 0.9.10) {
        Write-Output "Attempting to import Chocolatey PowerShell Profile..."
        $m = Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1 -PassThru -ErrorAction Continue
        if ($m) { refreshenv }
    }
}

Write-Output "`nInstalling/Updating NuGet and Chocolatey-AU.."
Install-PackageProvider -Name NuGet
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module "chocolatey-au" -Scope AllUsers -ErrorAction Stop
Get-Module "chocolatey-au" -ListAvailable | Select-Object Name, Version
