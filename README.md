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
- **Terminal & Font**: [iTerm2](https://iterm2.com/) + FiraCode Nerd Font
- **Custom Themes**: Custom tmux statusbar theme (`ka-tmux`)

---

## Included Configurations

| Configuration                                                                             | Target Path               | Description                                                 |
| :---------------------------------------------------------------------------------------- | :------------------------ | :---------------------------------------------------------- |
| [.zshrc](file:///Users/i/dotfile/.zshrc) / [.zprofile](file:///Users/i/dotfile/.zprofile) | `~/.zshrc`, `~/.zprofile` | Aliases, shell optimizations, PATH configuration            |
| [.tmux.conf](file:///Users/i/dotfile/.tmux.conf)                                          | `~/.tmux.conf`            | Mouse mode, prefix binding, split panes, 100k history limit |
| [ka-tmux/](file:///Users/i/dotfile/ka-tmux)                                               | `~/.tmux/themes/ka-tmux`  | Custom minimalist tmux theme & status line                  |
| [com.googlecode.iterm2.plist](file:///Users/i/dotfile/com.googlecode.iterm2.plist)        | Preferences               | Custom iTerm2 preferences and profile settings              |
| [nvim/](file:///Users/i/dotfile/nvim)                                                     | `~/.config/nvim`          | Neovim configuration                                        |
| [.vimrc](file:///Users/i/dotfile/.vimrc)                                                  | `~/.vimrc`                | Vim configuration                                           |

---

## Utility Scripts

The repository includes helper scripts for setting up tools and server environments:

### phpMyAdmin Auto Install (macOS)
Automates PHP, Composer, Laravel Valet, MySQL, and phpMyAdmin setup:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/KAnggara75/dotfile/main/pma.sh)"
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