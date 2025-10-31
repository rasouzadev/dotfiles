set -e

echo "======================================"
echo "Initializing WSL setup..."
echo "======================================"

# ================================
# Update and install base packages
# ================================
echo "Updating packages..."
sudo apt update -y && sudo apt upgrade -y

echo "Installing base dependencies..."
sudo apt install -y build-essential curl wget git unzip zip htop net-tools \
    ripgrep fd-find jq tree bat zsh fzf

# ================================
# Oh My Zsh + Powerlevel10k
# ================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# ================================
# Rust + exa (with icon support)
# ================================
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    rustup update
fi

if ! command -v exa &> /dev/null || [ "$(exa --version | grep -o 'v0.10.1')" = "" ]; then
    echo "Installing exa with full icon support..."
    cargo install exa
fi

# ================================
# Zsh configuration
# ================================
echo "Configuring Zsh..."

ZSHRC="$HOME/.zshrc"

cat > "$ZSHRC" <<'EOF'
# ===========================================
# ZSH CONFIGURATION
# ===========================================

# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z sudo fzf colorize history-substring-search)

source $ZSH/oh-my-zsh.sh

# ========== ALIASES ==========
alias cls='clear'
alias ls='exa --icons --group-directories-first'
alias ll='exa -lh --icons --group-directories-first'
alias la='exa -lha --icons --group-directories-first --git'
alias cat='batcat --style=plain --paging=never'
alias gs='git status'
alias gp='git pull'
alias gc='git commit -m'
alias gl='git log --oneline --graph --decorate'
alias dc='docker compose'
alias k='kubectl'
alias findf='fdfind'
alias grep='rg'
alias w='cd ~/workspace'
alias wm='cd ~/workspace/monorepo'
alias wb='cd ~/workspace/backend'
alias wf='cd ~/workspace/frontend'

# ========== ENV ==========
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export EDITOR="code --wait"
export VISUAL=$EDITOR

# ========== TOOLS ==========
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ========== POWERLEVEL10K ==========
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ========== PERFORMANCE ==========
zstyle ':completion:*' rehash true
autoload -Uz compinit && compinit -C
EOF

chsh -s $(which zsh)
echo "Zsh configured successfully. Restart your terminal to apply changes."

# ================================
# Workspace directories
# ================================
echo "Creating workspace directory structure..."
mkdir -p ~/workspace/{backend,frontend,infra,tools,monorepo}
echo "Workspace ready."

# ================================
# Optional installations
# ================================
echo ""
echo "--------------------------------------"
echo "Optional installations"
echo "--------------------------------------"

read -p "Install Node.js (via NVM)? [y/n]: " install_node
if [[ "$install_node" =~ ^[Yy]$ ]]; then
    echo "Installing Node.js..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
    nvm install --lts
fi

read -p "Install Go? [y/n]: " install_go
if [[ "$install_go" =~ ^[Yy]$ ]]; then
    echo "Installing Go..."
    sudo snap install go --classic
fi

read -p "Install Python? [y/n]: " install_python
if [[ "$install_python" =~ ^[Yy]$ ]]; then
    echo "Installing Python..."
    sudo apt install -y python3 python3-pip
fi

read -p "Install Docker? [y/n]: " install_docker
if [[ "$install_docker" =~ ^[Yy]$ ]]; then
    echo "Installing Docker..."
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "Docker installed successfully. Please log out and back in to apply user group changes."
fi

# ================================
# Final message
# ================================
echo ""
echo "======================================"
echo "WSL setup completed successfully!"
echo "Restart your terminal to apply all changes."
echo "======================================"