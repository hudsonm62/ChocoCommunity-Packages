#Name can be 'random N' to randomly force the Nth group of packages.

param( 
    [string[]] $Name, 
    [string] $Root = "$PSScriptRoot/packages" 
)
if (Test-Path $PSScriptRoot/update_vars.ps1) { 
    . $PSScriptRoot/update_vars.ps1 
}

$global:au_root = Resolve-Path $Root -ErrorAction Stop

if (($Name.Length -gt 0) -and ($Name[0] -match '^random (.+)')) {
    [array] $lsau = Get-AUPackages

    $group = [int]$Matches[1]
    $n = (Get-Random -Maximum $group)
    Write-Output "TESTING GROUP $($n+1) of $group"

    $group_size = [int]($lsau.Count / $group) + 1
    $Name = $lsau | Select-Object -First $group_size -Skip ($group_size * $n) | ForEach-Object { $_.Name }

    Write-Output ($Name -join ' ')
    Write-Output ('-' * 80)
}

$Options = [ordered]@{
    Force         = $true
    Push          = $false
    Timeout       = 600
    UpdateTimeout = 1200
    
    Report        = @{
        Type   = 'markdown'                                   # Report type: markdown or text
        Path   = "$PSScriptRoot\Update-Force-Test-${n}.md"    # Path where to save the report
        Params = @{                                           # Report parameters:
            Github_UserRepo = $Env:github_user_repo             #  Markdown: shows user info in upper right corner
            NoAppVeyor      = $true                             #  Markdown: do not show AppVeyor build shield
            Title           = "Update Force Test ${n}"  #  Markdown: title of the report
        }
    }
}


$global:info = updateall -Name $Name -Options $Options

# Upload step summary
# todo

$errorItems = $global:info | Where-Object { $_.Error -and $_.Error.Length -gt 0 }
$errorCount = $errorItems.Count
if ($errorCount -gt 0) {
    throw "There was $errorCount error(s)!"
}
