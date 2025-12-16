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

Write-Host "=== Step 1: Check if WSL is installed ===" -ForegroundColor Yellow
$wslInstalled = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | Select-Object -ExpandProperty State
if ($wslInstalled -eq "Enabled") {
    Write-Host "WSL is already installed." -ForegroundColor Green
} else {
    if (Ask-User "WSL is not installed. Enable it now?") {
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
        Write-Host "WSL feature enabled. Restart may be required." -ForegroundColor Green
    } else {
        Write-Host "Skipping WSL installation." -ForegroundColor Red
        exit
    }
}

Write-Host "`n=== Step 2: Check if Virtual Machine Platform is enabled ===" -ForegroundColor Yellow
$vmPlatform = Get-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform | Select-Object -ExpandProperty State
if ($vmPlatform -eq "Enabled") {
    Write-Host "Virtual Machine Platform is already enabled." -ForegroundColor Green
} else {
    if (Ask-User "Virtual Machine Platform is not enabled. Enable it now?") {
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
        Write-Host "Virtual Machine Platform enabled. Restart may be required." -ForegroundColor Green
    } else {
        Write-Host "Skipping Virtual Machine Platform installation." -ForegroundColor Red
        exit
    }
}

Write-Host "`n=== Step 3: Install WSL Kernel Update (if needed) ===" -ForegroundColor Yellow
if (Ask-User "Do you want to update/install the WSL kernel package?") {
    wsl --update
    Write-Host "WSL kernel updated." -ForegroundColor Green
}

Write-Host "`n=== Step 4: Install Ubuntu 24.04 ===" -ForegroundColor Yellow
if (Ask-User "Do you want to install Ubuntu 24.04 as your WSL distribution?") {
    wsl --install -d Ubuntu-24.04
    Write-Host "Ubuntu 24.04 installation initiated." -ForegroundColor Green
} else {
    Write-Host "Skipping Ubuntu installation." -ForegroundColor Red
    exit
}

Write-Host "`n=== Step 5: Verify Installation ===" -ForegroundColor Yellow
if (Ask-User "Do you want to verify that Ubuntu 24.04 is installed?") {
    wsl --list --verbose
    Write-Host "If you see 'Ubuntu-24.04' in the list above, installation was successful." -ForegroundColor Green
} else {
    Write-Host "Skipping verification." -ForegroundColor Red
}

Write-Host "`n=== Script Complete ===" -ForegroundColor Yellow
Write
