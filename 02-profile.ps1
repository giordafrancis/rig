# --- PowerShell Profile Setup Script ---
# Save to: ~/setup/profile-setup.ps1
# Sets env vars, power plan shortcuts, Jupyter alias, and suppresses PS7 nag

# 0. Check for existing profile — confirm overwrite
$profilePath = $PROFILE
if (Test-Path $profilePath) {
    $confirm = Read-Host "Existing profile found at $profilePath. Overwrite? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborted. Existing profile left in place."
        exit
    }
}

# 1. Prompt for paths
$personalProjects = (Read-Host "Enter personal projects path (e.g. C:\Users\<username>\personal_projects)").Trim()
$workDir = (Read-Host "Enter work directory path (resolved, not symlink)").Trim()

# 2. Prompt for power plan GUIDs
$highPerfGuid = Read-Host "Enter High Performance power plan GUID (default: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c)"
if ([string]::IsNullOrWhiteSpace($highPerfGuid)) { $highPerfGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" }
$balancedGuid = Read-Host "Enter Balanced power plan GUID (default: 381b4222-f694-41f0-9685-ff5bb260df2e)"
if ([string]::IsNullOrWhiteSpace($balancedGuid)) { $balancedGuid = "381b4222-f694-41f0-9685-ff5bb260df2e" }

# 3. Ensure profile directory exists
$profileDir = Split-Path $profilePath
if (-not (Test-Path $profileDir)) { mkdir $profileDir }

# 4. Write profile
@"
# Project paths (added: profile setup)
`$env:PERSONAL_PROJECTS = "$personalProjects"
`$env:WORK_DIR = "$workDir"

# Power plan shortcuts (added: profile setup)
function hipow { powercfg /setactive $highPerfGuid; Write-Host "Switched to High Performance" }
function lopow { powercfg /setactive $balancedGuid; Write-Host "Switched to Balanced" }

# Jupyter Lab launcher (added: profile setup)
function jl { jupyter lab --ServerApp.use_redirect_file=False }

# Suppress PS 7 upgrade nag (added: profile setup)
`$env:POWERSHELL_UPDATECHECK = 'Off'
"@ | Set-Content $profilePath

# 5. Verify
Write-Host "`nProfile written to $profilePath"
Write-Host "`n--- Contents ---"
Get-Content $profilePath