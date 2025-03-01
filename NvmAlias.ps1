function Invoke-PackageManagerVersion {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Version,
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    # Determine the package manager from the command name
    $commandName = $MyInvocation.InvocationName
    switch ($commandName) {
        "npmv" { $packageManager = "npm"; $pmExtension = ".cmd" }
        "yarnv" { $packageManager = "yarn"; $pmExtension = ".cmd" }
        "pnpmv" { $packageManager = "pnpm"; $pmExtension = ".cmd" }
        default { Write-Error "Unknown command '$commandName'. Use npmv, yarnv, or pnpmv."; return }
    }

    # Ensure version starts with 'v' if not provided
    if (-not $Version.StartsWith("v")) {
        $Version = "v$Version"
    }

    # Define the nvm root directory
    $nvmRoot = "$env:APPDATA\nvm"

    # Get all installed Node versions
    $installedVersions = Get-ChildItem -Path $nvmRoot -Directory | Where-Object { $_.Name -match "^v\d+(\.\d+)*$" }

    # Filter versions that match the input (e.g., "v22" matches "v22.*")
    $matchingVersions = $installedVersions | Where-Object { $_.Name -like "$Version*" }

    if (-not $matchingVersions) {
        Write-Error "No matching Node version found for '$Version'."
        return
    }

    # Sort versions and pick the latest one (or exact match if specified)
    $selectedVersion = $matchingVersions | Sort-Object Name -Descending | Select-Object -First 1
    foreach ($ver in $matchingVersions) {
        if ($ver.Name -eq $Version) {
            $selectedVersion = $ver
            break
        }
    }

    # Construct paths
    $pmPath = Join-Path -Path "$nvmRoot\$($selectedVersion.Name)" -ChildPath "$packageManager$pmExtension"
    $nodePath = Join-Path -Path "$nvmRoot\$($selectedVersion.Name)" -ChildPath "node.exe"

    if (-not (Test-Path $nodePath)) {
        Write-Error "Node not found in '$nvmRoot\$($selectedVersion.Name)'."
        return
    }

    # Check if the package manager exists (yarn/pnpm might need separate installation)
    if (-not (Test-Path $pmPath)) {
        Write-Error "$packageManager not found at '$pmPath'. Ensure it’s installed for Node $($selectedVersion.Name)."
        return
    }

    # Check if the user wants the Node version
    if ($Arguments -contains "--version" -or $Arguments -contains "-v") {
        Write-Host "Running with Node version: $($selectedVersion.Name)"
        & $nodePath --version
    } else {
        Write-Host "Running with Node version: $($selectedVersion.Name) using $packageManager"
        & $pmPath $Arguments
    }
}

# Set aliases for npmv, yarnv, and pnpmv
Set-Alias -Name npmv -Value Invoke-PackageManagerVersion
Set-Alias -Name yarnv -Value Invoke-PackageManagerVersion
Set-Alias -Name pnpmv -Value Invoke-PackageManagerVersion