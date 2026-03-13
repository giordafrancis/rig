# --- Miniforge Setup Script for Windows (PowerShell) ---
# No admin required. Installs for current user only.

# 0. Check for existing install and remove if confirmed
$INSTALL_DIR = "$env:USERPROFILE\miniforge3"
if (Test-Path $INSTALL_DIR) {
    $confirm = Read-Host "Existing miniforge found at $INSTALL_DIR. Remove it? (y/n)"
    if ($confirm -eq 'y') {
        Write-Host "Removing existing install..."
        Remove-Item -Recurse -Force $INSTALL_DIR
    } else {
        Write-Host "Aborted. Existing install left in place."
        exit
    }
}

# 1. Download
$DOWNLOAD = "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe"
$INSTALLER = "$env:USERPROFILE\Downloads\Miniforge3-Windows-x86_64.exe"
Write-Host "Downloading Miniforge installer..."
Invoke-WebRequest -Uri $DOWNLOAD -OutFile $INSTALLER

# 2. Silent install
Write-Host "Installing Miniforge..."
Start-Process -Wait -FilePath $INSTALLER -ArgumentList "/InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=$INSTALL_DIR"

# 3. Initialise conda for PowerShell
Write-Host "Initialising conda for PowerShell..."
& "$INSTALL_DIR\Scripts\conda.exe" init powershell

# 4. Clean up installer
Remove-Item $INSTALLER

Write-Host "Done! Close and reopen PowerShell, then run 'conda --version' to verify."