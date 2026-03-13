# --- Git Install & Configuration Script (PowerShell) ---
# Depends on: 02-profile.ps1 (needs $env:WORK_DIR)

# 0. Install git if not found
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing via winget..."
    winget install Git.Git
    Write-Host "Git installed. Please close and reopen PowerShell, then re-run this script."
    exit
}
Write-Host "Git found: $(git --version)"

# 1. Prompt for emails
$userName = (Read-Host "Enter git user.name").Trim()
if ([string]::IsNullOrWhiteSpace($userName)) {
    Write-Host "ERROR: user.name cannot be empty."
    exit
}
$personalEmail = (Read-Host "Enter your personal email (for GitHub)").Trim()
$workEmail = (Read-Host "Enter your work email").Trim()

# 2. Global config (personal = default)
git config --global user.name $userName
git config --global user.email $personalEmail
git config --global core.editor "code --wait"
git config --global init.defaultBranch "main"
git config --global core.autocrlf true

# 3. Create work-specific config file
$workConfig = "$env:USERPROFILE\.gitconfig-work"
@"
[user]
    email = $workEmail
"@ | Set-Content $workConfig
Write-Host "Created $workConfig"

# 4. Add conditional include — uses resolved path from profile env var
$workDirForward = $env:WORK_DIR -replace '\\','/'
git config --global --add "includeIf.gitdir:$workDirForward/.path" ".gitconfig-work"

# 5. Verify
Write-Host "`n--- Global .gitconfig ---"
Get-Content "$env:USERPROFILE\.gitconfig"
Write-Host "`n--- Work override (.gitconfig-work) ---"
Get-Content $workConfig