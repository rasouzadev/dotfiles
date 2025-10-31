set -e

echo "======================================"
echo "Initializing WSL setup..."
echo "======================================"

# ================================
# Update and install basic packages
# ================================
echo "Updating packages..."
sudo apt update -y && sudo apt upgrade -y

echo "Installing basic dependencies and productivity tools..."
sudo apt install -y build-essential curl wget git unzip zip htop net-tools \
    ripgrep fd-find jq tree bat exa zsh fzf

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
# .zshrc setup
# ================================
echo "Zsh setup..."

ZSHRC="$HOME/.zshrc"

cat > "$ZSHRC" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z sudo fzf extract colored-man web-search)

source $ZSH/oh-my-zsh.sh

# ===== Aliases =====
alias cls='clear'
alias ll='exa -lh --icons --group-directories-first'
alias la='exa -lha --icons --group-directories-first'
alias cat='batcat --style=plain --paging=never'
alias gs='git status'
alias gp='git pull'
alias gc='git commit -m'
alias dc='docker compose'
alias k='kubectl'

# ===== Paths =====
export PATH="$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR="code --wait"
export VISUAL=$EDITOR

# ===== FZF Integration =====
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
EOF

chsh -s $(which zsh)
echo "Zsh configured successfully! Restart your terminal to see the changes."

# ================================
# Workspace directory structure
# ================================
echo "Creating workspace directory structure (~/workspace)..."
mkdir -p ~/workspace/{backend,frontend,infra,tools,monorepo}
echo "Workspace structure created."

# ================================
# Optional installations
# ================================
echo ""
echo "--------------------------------------"
echo "Optional installations"
echo "--------------------------------------"

read -p "→ Do you want to install Node.js (NVM)? [y/n]: " install_node
if [[ "$install_node" =~ ^[Yy]$ ]]; then
    echo "Installing Node.js (via NVM)..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
    fi
    nvm install --lts
    echo "Node.js (LTS) installed successfully!"
fi

read -p "→ Do you want to install Go? [y/n]: " install_go
if [[ "$install_go" =~ ^[Yy]$ ]]; then
    echo "Installing Go (via Snap)..."
    sudo snap install go --classic
    echo "Go installed successfully!"
fi

read -p "→ Do you want to install Python? [y/n]: " install_python
if [[ "$install_python" =~ ^[Yy]$ ]]; then
    echo "Installing Python and Pip..."
    sudo apt install -y python3 python3-pip
    echo "Python installed successfully!"
fi

read -p "→ Do you want to install Docker? [y/n]: " install_docker
if [[ "$install_docker" =~ ^[Yy]$ ]]; then
    echo "Installing Docker components..."
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "Docker installed successfully! Please log out and back in to apply user group changes."
fi

# ================================
# Final message
# ================================
echo ""
echo "======================================"
echo "WSL setup completed successfully!"
echo "Please restart your terminal."
echo "======================================"