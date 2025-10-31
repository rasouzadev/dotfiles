# WSL Dev Environment Setup

An automated setup script designed to quickly configure a robust and modern development environment within WSL2.
This script installs essential productivity tools, sets up Zsh with Powerlevel10k, and provides interactive options to install popular programming languages and Docker.

## Features

* Modern Shell: Sets up Zsh with Oh My Zsh and the Powerlevel10k theme for a highly customized and informative prompt.
* Essential Tools: Installs key command-line utilities like `exa`, `bat`, `fzf`, `ripgrep`, `jq`, `fd`, and `tree`.
* Interactive Installation: Provides optional and interactive installation of Node.js (via NVM), Go, Python, and Docker.
* Professional Workspace: Creates a structured `~/workspace` directory with standard subfolders (`backend`, `frontend`, `infra`, `tools`, `monorepo`).
* Idempotency: Designed to be safe to run multiple times without causing issues (e.g., skips Zsh/P10k installation if already present).

## Prerequisites

* Windows 10/11 with WSL2 enabled.
* Distribution: Ubuntu 22.04 LTS (or newer) is recommended.
* Active internet connection.
* `sudo` permissions.

## Installation

To run the setup, clone this repository or execute the script directly using `curl`:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/rasouza/dotfiles/wsl/setup.sh)
```

## Post-Installation

The script automatically sets Zsh as your default shell. For all changes to take effect immediately, you may need to close and reopen your WSL terminal, or run:

```bash
source ~/.zshrc
```