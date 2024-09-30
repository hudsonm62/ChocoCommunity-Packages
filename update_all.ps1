# Based on AU Packages Template: https://github.com/majkinetor/au-packages-template

param(
    [string] $Name, 
    [string] $ForcedPackages, 
    [string] $Root = "$PSScriptRoot\packages", 
    [uri]$SourceUri, [switch]$PackNPush = $false, [switch]$SkipChocoVersionCheck = $false
)

if (Test-Path $PSScriptRoot/update_vars.ps1) { . $PSScriptRoot/update_vars.ps1 }
$historyUrl = "https://github.com/hudsonm62/ChocoCommunity-Packages/actions/workflows/au-updater.yml"

$Options = [ordered]@{
    Timeout             = 100                                   # Connection timeout in seconds
    UpdateTimeout       = 1200                                  # Update timeout in seconds
    Threads             = 10                                    # Number of background jobs to use
    Push                = $false
    PluginPath          = ''                                    # Path to user plugins
    NoCheckChocoVersion = $SkipChocoVersionCheck                # Skip Chocolatey Community version comparison

    Report              = @{
        Type   = 'markdown'                                     # Report type: markdown or text
        Path   = "$PSScriptRoot\Update-AUPackages.md"           # Path where to save the report
        Params = @{                                             # Report parameters:
            Github_UserRepo = $Env:github_user_repo             #  Markdown: shows user info in upper right corner
            NoAppVeyor      = $true                             #  Markdown: do not show AppVeyor build shield
            UserMessage     = "[History]($historyUrl)"          #  Markdown, Text: Custom user message to show
            NoIcons         = $false                            #  Markdown: don't show icon
            IconSize        = 32                                #  Markdown: icon size
            Title           = 'Package Update Report'           #  Markdown, Text: Title of the report, by default 'Update-AUPackages'
        }
    }

    RunInfo             = @{
        Exclude = 'password', 'apikey', 'apitoken'              # Option keys which contain those words will be removed
        Path    = "$PSScriptRoot\update_info.xml"               # Path where to save the run info
    }

    ForcedPackages      = $ForcedPackages -split ' '
    BeforeEach          = {
        param($PackageName, $Options )
        $p = $Options.ForcedPackages | Where-Object { $_ -match "^${PackageName}(?:\:(.+))*$" }
        if (!$p) { return }

        $global:au_Force = $true
        $global:au_Version = ($p -split ':')[1]
    }
}

if ($ForcedPackages) { Write-Output "FORCED PACKAGES: $ForcedPackages" }

$global:au_Root = $Root # Path to the AU packages
$global:info = updateall -Name $Name -Options $Options

# Upload step summary
# todo

if ($PackNPush -eq $true) {
    $updatedPkgsCount = 0
    foreach ($package in $global:info) {
        $PkgName = $package.Name
        $package_dir = $package.Path
        if ($package.Updated -ne $true) {
            Write-Output "Package '$PkgName' was not updated, skipping pack/push..."
            continue
        }
        if (!(Test-Path $package_dir)) {
            Write-Output "::warning file=update_all.ps1 title=Missing $PkgName::'$PkgName' could not be located at '$package_dir' despite being updated by AU."
            continue
        }

        try {
            Write-Output "PACKAGING: $PkgName"
            Push-Location $package_dir
            choco pack
            if ($null -eq $SourceUri) {
                Write-Warning "SourceUri variable is null - Skipping 'choco push'.."
            }
            else {
                Write-Output "Pushing to '$SourceUri'"
                choco push --source $SourceUri # set apikey with 'choco apikey set'
                $updatedPkgsCount += 1
            }
        }
        catch {
            Write-Output "::error file=update_all.ps1 title=$PkgName Packaging Error::$_"
        }
        finally {
            Pop-Location 
        }

    }
    Write-Output "::notice file=update_all.ps1::$($global:info.Count) scanned, $updatedPkgsCount updated and pushed."
}

$errorItems = $global:info | Where-Object { $_.Error -and $_.Error.Length -gt 0 }
$errorCount = $errorItems.Count
if ($errorCount -gt 0) {
    throw "There was $errorCount error(s)!"
}
