Import-Module Chocolatey-AU

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url64bit\s*=\s*)('.*')"       = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
        "openxr-explorer.nuspec"        = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`$1$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $headers = @{
        "Accept"               = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
    }
    $url = "https://api.github.com/repos/maluoi/openxr-explorer/releases/latest"
    $release = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $versionMatch = $release.name | Select-String -Pattern 'v?(\d+(\.\d+)*)' -AllMatches
    $version = $versionMatch.Matches[0].Groups[1].Value

    return @{
        Version      = $version
        URL64        = ($release.assets | Where-Object { $_.name -like "*win*.zip" -or $_.name -like "*windows*.zip" }).browser_download_url
        ReleaseNotes = $release.html_url
    }
}

update -ChecksumFor 64
