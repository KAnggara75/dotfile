# KAnggara Dotfiles

My personal dotfiles and development environment configuration for macOS and Linux.

## Quick Start / Installation

Run the automatic installer script:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/install.sh)"
```

### What gets installed & configured:
- **Package Manager**: [Homebrew](https://brew.sh/) (macOS)
- **Shell**: [Zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/)
- **Zsh Plugins**:
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
  - `zsh-bat`
  - `you-should-use`
- **CLI Tools**: [lsd](https://github.com/lsd-rs/lsd), [tmux](https://github.com/tmux/tmux), [git](https://git-scm.com/)
- **Terminal & Font**: [Ghostty](https://ghostty.org/) + FiraCode Nerd Font
- **Custom Themes**: Custom tmux statusbar theme (`ka-tmux`)

---

## Included Configurations

| Configuration                                          | Target Path                         | Description                                                              |
| :----------------------------------------------------- | :---------------------------------- | :----------------------------------------------------------------------- |
| [.zshenv](file:///.zshenv)                             | `~/.zshenv`                         | Global environment variables, runtimes, SDKs, and clean PATH setup       |
| [.zshrc](file:///.zshrc)                               | `~/.zshrc`                          | Interactive shell configuration, Oh My Zsh plugins, aliases, and prompts |
| [.zprofile](file:///.zprofile)                         | `~/.zprofile`                       | Login shell configuration, SSH agent management, Homebrew environment    |
| [.zshrc.secret.example](file:///.zshrc.secret.example) | `~/.zshrc.secret`                   | Template for local tokens and secrets (ignored from git tracking)        |
| [.tmux.conf](file:///.tmux.conf)                       | `~/.tmux.conf`                      | Mouse mode, prefix binding, split panes, 100k history limit              |
| [ka-tmux/](file:///ka-tmux)                            | `~/.tmux/themes/ka-tmux`            | Custom minimalist tmux theme & status line                               |
| [config.ghostty](file:///config.ghostty)               | `~/Library/Application Support/...` | GPU-accelerated terminal emulator configuration (Ayu theme)              |
| [nvim/](file:///nvim)                                  | `~/.config/nvim`                    | Neovim configuration                                                     |
| [.vimrc](file:///.vimrc)                               | `~/.vimrc`                          | Vim configuration                                                        |

---

## Utility Scripts

The repository includes helper scripts for setting up tools and server environments:

### Default Browser Switcher & Raycast Integration
Switches default browser with automatic cycling (Safari $\rightarrow$ Edge $\rightarrow$ Chrome $\rightarrow$ Safari) or via Raycast script command:

```bash
swbr        # Cycle to next browser
swbr s      # Switch to Safari
swbr e      # Switch to Microsoft Edge
swbr c      # Switch to Google Chrome
```

### Git SSH Signing Setup
Configures commit signing with an existing SSH key:

```bash
./setup/gitsetup.sh
```

### Docker Setup (Ubuntu / Debian)
Installs Docker CE, CLI, Buildx, and Compose plugin with systemd daemon setup:

```bash
./setup/docker.sh
```

### Linux Swap Allocation
Calculates and configures optimal swap space based on total RAM:

```bash
./swap.sh
```

---

## Repository Remote Configuration

Switch from HTTPS to SSH remote:

```bash
git remote set-url origin git@github.com:KAnggara75/dotfile.git
git remote -v
```