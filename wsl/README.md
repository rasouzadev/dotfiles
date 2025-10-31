# WSL Dev Environment Setup

An automated setup script to configure a modern and efficient development environment for WSL2.  
It installs Zsh with Powerlevel10k, productivity tools, and optional languages such as Node.js, Go, Python, and Docker.

---

## Features

- **Modern Shell**: Installs Zsh with Oh My Zsh and Powerlevel10k theme.
- **Essential Tools**: Includes `exa`, `bat`, `fzf`, `ripgrep`, `jq`, `fd`, and `tree`.
- **Language Options**: Interactive installation for Node.js (via NVM), Go, Python, and Docker.
- **Workspace Layout**: Creates a professional folder structure at `~/workspace` with subfolders (`backend`, `frontend`, `infra`, `tools`, `monorepo`).
- **Safe Re-runs**: Idempotent — safely rerun without reinstalling components unnecessarily.

---

## Prerequisites

- Windows 10/11 with **WSL2 enabled**
- Recommended distribution: **Ubuntu 22.04 LTS**
- Active internet connection
- `sudo` privileges

---

## Installation

Run directly using `curl`:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rasouzadev/dotfiles/main/wsl/setup.sh)
```

## Post-Installation

The script automatically sets Zsh as your default shell. For all changes to take effect immediately, you may need to close and reopen your WSL terminal, or run:

```bash
source ~/.zshrc
```