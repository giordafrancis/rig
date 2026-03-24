# --- 08-bloatware.ps1 — Remove Pre-installed Bloatware ---
# Run in: Admin PowerShell (recommended, though most work without)
#
# How to get your current app list:
#   Get-AppxPackage | Select-Object Name | Sort-Object Name
#
# To copy it to clipboard for review:
#   Get-AppxPackage | Select-Object Name | Sort-Object Name | Set-Clipboard
#
# Notes:
# - This only removes apps for the CURRENT user (not system-wide)
# - Removed apps won't reappear unless a Windows feature update re-provisions them
# - To remove system-wide (prevent for new users too), add -AllUsers flag
# - Some system packages (runtimes, Shell, Store) cannot and should not be removed

# --- Removal list ---
# Each entry includes a comment explaining why it's flagged
$remove = @(
    "McAfeeWPSSparsePackage"                    # Bundled antivirus — Windows Defender is sufficient
    "Microsoft.BingSearch"                       # Start menu Bing integration — unnecessary
    "Microsoft.BingWeather"                      # Weather app — use browser instead
    "Microsoft.GetHelp"                          # Microsoft help app — rarely useful
    "Microsoft.MicrosoftSolitaireCollection"     # Games — not needed on a workstation
    "Microsoft.WindowsFeedbackHub"               # Telemetry/feedback — already locked down in 01-privacy.ps1
    "Microsoft.YourPhone"                        # Phone Link — USB-C file transfer preferred
    "Microsoft.ZuneMusic"                        # Groove Music / Media Player — not needed
    "Clipchamp.Clipchamp"                        # Video editor — not needed for data science work
    "MicrosoftCorporationII.MicrosoftFamily"     # Parental controls — not applicable
    "Microsoft.Todos"                            # Task list app — not used (Sticky Notes kept separately)
    "Microsoft.M365Companions"                   # Promotional nudges for M365 features — not the actual apps
    "IntelligoTechnologyInc.541271065CCE8"       # ASUS AI bloatware
    "Microsoft.Windows.DevHome"                  # Dev dashboard — never used, redundant with existing workflow
    "B9ECED6F.ASUSExpertWidget"                  # ASUS system widget — redundant with MyASUS + HWMonitor
    "B9ECED6F.ASUSPCAssistant"                   # ASUS diagnostics — redundant with MyASUS + HWMonitor
)

# --- Execute removal ---
foreach ($app in $remove) {
    $pkg = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
    if ($pkg) {
        Write-Host "Removing $app..."
        $pkg | Remove-AppxPackage
    } else {
        Write-Host "SKIP (not found): $app"
    }
}

Write-Host "`nDone! Run the app list command above to verify removals."
