# --- SSH Key Setup Script (PowerShell) ---
# Assumes .ssh folder already copied manually to $env:USERPROFILE\.ssh

# 1. Check .ssh folder exists
$sshDir = "$env:USERPROFILE\.ssh"
if (-not (Test-Path $sshDir)) {
    Write-Host "ERROR: $sshDir not found. Copy your .ssh folder there first."
    exit
}

# 2. Fix permissions — restrict private keys to current user only
$keyFiles = Get-ChildItem $sshDir -File | Where-Object { $_.Name -notmatch '\.pub$' -and $_.Name -ne 'known_hosts' -and $_.Name -ne 'config' }
foreach ($key in $keyFiles) {
    Write-Host "Fixing permissions: $($key.Name)"
    icacls $key.FullName /inheritance:r /grant:r "${env:USERNAME}:(R)"
}

# 3. Print fingerprint(s) so you can verify against GitHub
$pubKeys = Get-ChildItem $sshDir -Filter "*.pub"
foreach ($pub in $pubKeys) {
    Write-Host "`nFingerprint for $($pub.Name):"
    ssh-keygen -lf $pub.FullName
}

Write-Host "`nDone! Verify with: ssh -T git@github.com"