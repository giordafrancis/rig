# --- Folder Structure Script (PowerShell) ---
# Depends on: 02-profile.ps1 (needs $env:PERSONAL_PROJECTS and $env:WORK_DIR)
# May need admin PowerShell for symlink creation

# 1. Create personal projects folder (skip if exists)
$ppDir = $env:PERSONAL_PROJECTS
if (-not (Test-Path $ppDir)) {
    mkdir $ppDir
    Write-Host "Created $ppDir"
} else {
    Write-Host "SKIP: $ppDir already exists"
}

# 2. Create symlink: ~/work → OneDrive work path (skip if exists)
#    REQUIRES: OneDrive sync completed first
$workLink = "$env:USERPROFILE\work"
if (-not (Test-Path $workLink)) {
    New-Item -ItemType SymbolicLink -Path $workLink -Target $env:WORK_DIR
    Write-Host "Created symlink $workLink"
} else {
    Write-Host "SKIP: $workLink already exists"
}

# 3. Restore Jupyter Lab settings (fail if source not found)
$jlSource = "$env:USERPROFILE\setup\jupyter-lab-user-settings"
$jlTarget = "$env:USERPROFILE\.jupyter\lab\user-settings"
if (-not (Test-Path $jlSource)) {
    Write-Host "ERROR: Jupyter Lab settings not found at $jlSource. Back up from old machine or pull from GitHub first."
    exit 1
}
if (-not (Test-Path $jlTarget)) { mkdir $jlTarget }
Copy-Item -Recurse -Force "$jlSource\*" $jlTarget
Write-Host "Restored Jupyter Lab settings to $jlTarget"

Write-Host "Done! Verify with: ls ~\work"