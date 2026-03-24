# Manual / Machine-Specific Settings

These were configured through the Windows UI — not scripted, as they depend on individual hardware and preference.

**Display Scaling:**
- Display 1 (laptop 14", 1920×1080) — set to **150%**
- Display 2 (external, 1920×1080) — left at **100%**
- Display arrangement: external above laptop (matches physical setup)
- Note: the Settings diagram doesn't reflect actual screen sizes — it's just for positioning

**Copilot Key Remap (PowerToys):**
- Win(Left) + Shift(Left) + F23 → Ctrl(Right) (All Apps)
- Requires PowerToys installed and running at startup
- **Important:** Enable "Run as administrator" in PowerToys General settings — otherwise remaps are ignored in elevated apps (e.g. Windows Terminal)

**PowerShell 7 — NoLogo:**
- Windows Terminal → Settings → PowerShell profile → Command line → `pwsh.exe -NoLogo`
- Suppresses the version banner on launch

**Default Apps:**
- Browser — Firefox
- PDF viewer — Firefox
- Email client — Outlook

**VS Code:**
- Settings Sync enabled via Lambeth (Microsoft) account — extensions, settings, keybindings, snippets all carried over

**Accessibility — Text Size:**
- Settings → Accessibility → Text size — decrease to control size at recommended scaling
- Had the best impact on Outlook UI sizing (better than DPI overrides, which were blocked by Click-to-Run)

**Outlook:**
- Switched to **New Outlook** (classic Outlook retired)

**WSL 2 + Ubuntu:**
- Installation is a manual step (requires admin PowerShell + reboot + interactive username/password setup)
- See **WSL Setup** section for full steps

**ASUS Product Registration:**
- Registered via MyASUS app (serial number + purchase date)

**Battery Care (MyASUS):**
- **Battery Care Mode** → On (caps charge at 80% — extends battery lifespan)
- **Instant Full-Charge Mode** → Off by default; toggle On before travel when 100% needed — auto-reverts to 80% cap after 24 hours
- MyASUS was removed during bloatware cleanup — reinstalled from Microsoft Store

**McAfee Removal:**
- Not removed by `08-bloatware.ps1` — required manual uninstall
- Settings → Apps → Installed apps → search "McAfee" → Uninstall each entry
- If remnants remain, use the official **McAfee Consumer Product Removal tool (MCPR)** from McAfee's support site

**AI ExpertMeet + Plugin Removal:**
- Removed manually via Settings → Apps → Installed apps
- AI ExpertMeet (380 MB) + AI ExpertMeet Plugin (7.79 GB) — ~8 GB freed
- Reason: duplicate functionality already covered by Teams/Zoom built-in AI features

**Startup Apps Disabled (via Task Manager):**
- ASUS ExpertPanel
- panel (ASUS ExpertPanel launcher — system-level duplicate)
- ONENOTEM (Send to OneNote)
- Mobile devices (Windows phone integration)
- Spotify
- ms-teams (duplicate Teams entry)
- WhatsApp

**Notifications Disabled (via Settings → System → Notifications):**
- Microsoft Store
- Screen Sketch (Snipping Tool)
- Startup App toast
- ASUS PCAssistant, Phone Link — orphaned entries (apps already removed via 08-bloatware.ps1, will clear after reboot)
