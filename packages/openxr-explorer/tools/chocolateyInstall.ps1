$ErrorActionPreference = 'Stop'
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = $toolsPath

$packageArgs = @{
    packageName    = 'openxr-explorer'
    url64bit       = 'https://github.com/maluoi/openxr-explorer/releases/download/v1.4/openxr-explorer-win-x64.zip'
    checksum64     = ''
    checksumType64 = ''
    UnzipLocation  = $installDir
}

Install-ChocolateyZipPackage @packageArgs
if ($installDir -ne $toolsPath) {
    Install-ChocolateyPath $installDir 
}

## Shim Generation
# Note: openxr-explorer.exe doubles as a gui and a cli
# Using a .gui shim causes cli commands to 'wait' (hang) after execution, but not specifying one when using the gui causes a loose parent terminal window to spawn
# Right now, I dont know a simple way around this without a wrapper, so this will do for now since most people won't even use it.
## https://docs.chocolatey.org/en-us/features/shim/
if (!(Get-PackageParameters)['SkipGuiShim']) {
    $oxreBin = Get-Item -Path $(Join-Path $installDir "openxr-explorer.exe") -Force
    Write-Host " Creating $($oxreBin.Name).gui dummy file for shim.."
    New-Item "$($oxreBin.Name).gui" -ItemType File -Force | Out-Null
}
else {
    Write-Warning "Skipping .gui shim creation due to /SkipGuiShim - You typically don't need to specify this unless you're working closely with the openxr-explorer.exe CLI"
}
