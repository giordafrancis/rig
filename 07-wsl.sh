#!/usr/bin/env bash
# --- wsl-setup.sh — WSL Ubuntu Setup Script ---
# Run with: sudo bash /mnt/c/Users/<username>/setup/07-wsl.sh
# Depends on: 04-ssh.ps1 (SSH keys must be set up on Windows first)
set -e

# Prompt for Windows username
read -p "Enter your Windows username: " WINDOWS_USER
if [ -z "$WINDOWS_USER" ]; then
    echo "ERROR: Windows username cannot be empty."
    exit 1
fi
WSL_USER="${SUDO_USER:-$USER}"
WSL_HOME="/home/$WSL_USER"

echo "=== WSL Setup for $WSL_USER (Windows user: $WINDOWS_USER) ==="

# --- 1. System upgrade ---
echo -e "\n>>> 1. System upgrade"
apt update && apt upgrade -y

# --- 2. apt-fast (parallel apt downloads) ---
echo -e "\n>>> 2. Installing apt-fast"
apt install -y software-properties-common
add-apt-repository -y ppa:apt-fast/stable
apt update
apt install -y apt-fast

# --- 3. Bulk install ---
echo -e "\n>>> 3. Bulk apt install"
apt-fast install -y \
    unzip \
    wslu \
    build-essential \
    vim \
    wget \
    curl \
    ca-certificates \
    gnupg

# --- 4. SSH keys (copy from Windows) ---
echo -e "\n>>> 4. SSH keys"
SSH_SRC="/mnt/c/Users/$WINDOWS_USER/.ssh"
SSH_DEST="$WSL_HOME/.ssh"
if [ ! -d "$SSH_SRC" ]; then
    echo "⚠️  WARNING: $SSH_SRC not found — set up SSH on Windows first!"
    echo "   Skipping SSH key copy."
else
    if [ -d "$SSH_DEST" ]; then
        read -p "   $SSH_DEST already exists. Overwrite? (y/n) " confirm
        if [ "$confirm" != "y" ]; then
            echo "   Skipping SSH key copy."
        else
            rm -rf "$SSH_DEST"
        fi
    fi
    if [ ! -d "$SSH_DEST" ]; then
        cp -r "$SSH_SRC" "$SSH_DEST"
        chown -R "$WSL_USER:$WSL_USER" "$SSH_DEST"
        chmod 700 "$SSH_DEST"
        chmod 600 "$SSH_DEST"/*
        chmod 644 "$SSH_DEST"/*.pub 2>/dev/null || true
        echo "   SSH keys copied and permissions set."
    fi
fi

# --- 5. AWS CLI ---
echo -e "\n>>> 5. AWS CLI"
if command -v aws &>/dev/null; then
    echo "   AWS CLI already installed: $(aws --version)"
else
    cd /tmp
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    ./aws/install
    rm -rf awscliv2.zip aws/
    echo "   AWS CLI installed: $(aws --version)"
fi

# --- 6. nvm + Node.js + CDK ---
echo -e "\n>>> 6. nvm + Node.js + AWS CDK"
if [ -d "$WSL_HOME/.nvm" ]; then
    echo "   nvm already installed — skipping."
else
    sudo -u "$WSL_USER" bash -c '
        NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "\"tag_name\"" | sed -E "s/.*\"([^\"]+)\".*/\1/")
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
    '
fi
# Source nvm and install Node + CDK as the user
sudo -u "$WSL_USER" bash -c '
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    if ! command -v node &>/dev/null; then
        nvm install --lts
    else
        echo "   Node.js already installed: $(node --version)"
    fi
    if ! command -v cdk &>/dev/null; then
        npm install -g aws-cdk
    else
        echo "   CDK already installed: $(cdk --version)"
    fi
'

# --- 7. Docker Engine ---
echo -e "\n>>> 7. Docker Engine"
if command -v docker &>/dev/null; then
    echo "   Docker already installed: $(docker --version)"
else
    curl -fsSL https://get.docker.com | sh
fi
usermod -aG docker "$WSL_USER"
echo "   $WSL_USER added to docker group."

# --- 8. Browser integration ---
echo -e "\n>>> 8. Browser integration (wslview)"
BASHRC="$WSL_HOME/.bashrc"
if grep -q "BROWSER=wslview" "$BASHRC" 2>/dev/null; then
    echo "   Already configured."
else
    echo 'export BROWSER=wslview' >> "$BASHRC"
    chown "$WSL_USER:$WSL_USER" "$BASHRC"
    echo "   Added BROWSER=wslview to .bashrc"
fi

# --- 9. Hush login ---
echo -e "\n>>> 9. Silence daily WSL welcome message"
HUSHFILE="$WSL_HOME/.hushlogin"
if [ -f "$HUSHFILE" ]; then
    echo "   Already hushed."
else
    touch "$HUSHFILE"
    chown "$WSL_USER:$WSL_USER" "$HUSHFILE"
    echo "   Created .hushlogin"
fi

# --- Done ---
echo -e "\n=== Setup complete! ==="
echo "Next steps:"
echo "  1. Close and reopen your terminal"
echo "  2. Run: docker run hello-world"
echo "  3. Run: aws sso login"
echo "  4. Run: ssh -T git@github.com"