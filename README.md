# rig

Opinionated Windows 11 Pro workstation setup for data science.

Scripts to go from a fresh install to a fully configured machine — single user account, soft boundaries between work and personal, conda environments for isolation.

> **Take or leave it.** This reflects one person's preferences. Fork it, cherry-pick what's useful, skip what isn't.

## Target Machine

- Windows 11 Pro
- No dedicated GPU (cloud GPU for deep learning — not covered here)
- WSL 2 + Ubuntu for Linux tooling

## Scripts

Run in suggested order. No orchestrator — pick what you need.

| # | Script | Description | Depends on | Requires admin |
|---|---|---|---|---|
| 01 | `01-privacy.ps1` | Disable telemetry, ads, activity tracking | — | Yes |
| 02 | `02-profile.ps1` | PowerShell profile — env vars, aliases, power plan shortcuts | — | No |
| 03 | `03-miniforge.ps1` | Miniforge silent install (conda-forge + mamba) | — | No |
| 04 | `04-ssh.ps1` | SSH key permissions fix + fingerprint verify | — | No |
| 05 | `05-folders.ps1` | Create project folders + work symlink | 02 | Maybe (symlinks) |
| 06 | `06-git.ps1` | Git install + config (conditional work/personal identity) | 02 | No |
| 07 | `07-wsl.sh` | WSL Ubuntu setup — AWS CLI, nvm, Node, CDK, Docker | 04 | Yes (runs with sudo) |

### Conda Environment

After miniforge is installed:

```powershell
conda env update -n base --file base.yaml
```

## Security Notes

- **No secrets in this repo.** SSH keys and AWS credentials are transferred manually via USB — never scripted.
- Some scripts use `curl | sh` for Docker and nvm installs — this is the official method for both, but review the URLs if that makes you uncomfortable.
- The `apt-fast` PPA (`ppa:apt-fast/stable`) is third-party — skip it if you prefer stock apt.
- All scripts that need personal info (emails, paths, usernames) **prompt at runtime** — nothing is hardcoded.

## Manual Steps

Some things aren't scripted — see the comments in each script or notes below:

- Display scaling and multi-monitor arrangement
- Default apps (browser, PDF viewer, email)
- VS Code Settings Sync (sign in manually)
- Copilot key remap (PowerToys)
- WSL install + Ubuntu distro (`wsl --install -d Ubuntu` — requires reboot)
- OneDrive sync (must complete before folder setup)
- Copy `.ssh` and `.aws` folders via USB


## LLM-Friendly Docs

This repo includes an [`llms.txt`](llms.txt) file following the [llmstxt.org](https://llmstxt.org/) standard — a concise, markdown-formatted summary of the repo designed for use with large language models. Point your LLM at it for quick context on the scripts and their dependencies.

## License

MIT