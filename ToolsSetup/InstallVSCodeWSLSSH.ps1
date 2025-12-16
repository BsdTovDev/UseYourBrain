# Ensure script runs with admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator."
    exit
}

function Ask-User($message) {
    Write-Host $message -ForegroundColor Cyan
    $response = Read-Host "Do you want to proceed? (Y/N)"
    return $response -match '^[Yy]'
}

Write-Host "=== Installing VS Code WSL Tools ===" -ForegroundColor Yellow

# Check if VS Code is installed
$VSCodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
if (-not (Test-Path $VSCodePath)) {
    Write-Error "VS Code not found. Please install Visual Studio Code first."
    exit
}

# Check if WSL is installed
try {
    wsl --version | Out-Null
    Write-Host "WSL is installed." -ForegroundColor Green
} catch {
    Write-Error "WSL is not installed. Please install WSL before running this script."
    exit
}

# Extensions list
$extensions = @(
    "ms-vscode-remote.remote-wsl",        # Remote - WSL
    "ms-vscode-remote.remote-containers", # Remote - Containers
    "ms-vscode-remote.remote-ssh"         # Remote - SSH
)

foreach ($ext in $extensions) {
    if (Ask-User "Do you want to install VS Code extension: $ext ?") {
        Write-Host "Installing extension: $ext" -ForegroundColor Cyan
        & $VSCodePath --install-extension $ext
        Write-Host "Extension $ext installed." -ForegroundColor Green
    } else {
        Write-Host "Skipped extension: $ext" -ForegroundColor Yellow
    }
}

Write-Host "`n=== Step: Verify Installed Extensions ===" -ForegroundColor Yellow
if (Ask-User "Do you want to list all installed VS Code extensions now?") {
    & $VSCodePath --list-extensions
    Write-Host "Above is the list of installed extensions." -ForegroundColor Green
} else {
    Write-Host "Skipped extension verification." -ForegroundColor Yellow
}

Write-Host "`n=== Step: Restart VS Code ===" -ForegroundColor Yellow
if (Ask-User "Do you want to restart VS Code now?") {
    Start-Process "Code.exe"
    Write-Host "VS Code restarted." -ForegroundColor Green
} else {
    Write-Host "Skipped VS Code restart." -ForegroundColor Yellow
}

Write-Host "`n=== VS Code WSL Tools installation complete ===" -ForegroundColor Green
Write-Host "You can now use VS Code with WSL (Ubuntu 24.04 or other distros)." -ForegroundColor Magenta
