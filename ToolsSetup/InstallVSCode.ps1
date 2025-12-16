# Ensure script runs with admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator."
    exit
}

# Use TLS 1.2 for secure downloads
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define download URL for latest VS Code (System Installer, 64-bit)
$VSCodeUrl = "https://update.code.visualstudio.com/latest/win32-x64-user/stable"

# Define local installer path
$InstallerPath = "$env:TEMP\vscode-latest.exe"

Write-Host "Downloading Visual Studio Code latest installer..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $VSCodeUrl -OutFile $InstallerPath

# Ask user before running installer
$response = Read-Host "Do you want to run the VS Code installer now? (Y/N)"
if ($response -match '^[Yy]') {
    Write-Host "Launching Visual Studio Code installer (interactive)..." -ForegroundColor Cyan
    Start-Process -FilePath $InstallerPath -Wait
    Write-Host "Visual Studio Code installation process finished." -ForegroundColor Green
} else {
    Write-Host "Installer downloaded but not launched. You can run it manually from: $InstallerPath" -ForegroundColor Yellow
}

# Verify installation
$VSCodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"
if (Test-Path $VSCodePath) {
    Write-Host "VS Code installed successfully at: $VSCodePath" -ForegroundColor Green
} else {
    Write-Host "VS Code installation not found. Please check manually." -ForegroundColor Red
}
