# Ensure TLS 1.2 is used for secure downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define GitHub release API URL for PowerShell
$ReleaseUrl = "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"

# Download release metadata
Write-Host "Fetching latest PowerShell release info..."
$Release = Invoke-RestMethod -Uri $ReleaseUrl -UseBasicParsing

# Find the latest 64-bit MSI installer asset
$Asset = $Release.assets | Where-Object { $_.name -like "*win-x64.msi" } | Select-Object -First 1

if (-not $Asset) {
    Write-Error "Could not find MSI installer in the latest release."
    exit 1
}

# Define local file path
$InstallerPath = "$env:TEMP\$($Asset.name)"

# Download the MSI installer
Write-Host "Downloading $($Asset.name)..."
Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $InstallerPath

# Install PowerShell silently
Write-Host "Installing PowerShell..."
Start-Process msiexec.exe -ArgumentList "/i `"$InstallerPath`" /quiet /norestart" -Wait

# Verify installation
Write-Host "Installation complete. Checking version..."
& "$env:ProgramFiles\PowerShell\7\pwsh.exe" -Version
