# Codebase Navigation Map

## Root Shell & Environment
- **Responsibility**: Mengelola bootstrap lifecycle shell Zsh, environment variable global, SSH agent, dan secret lokal.
- **Entry / Key Files**:
  - [.zshenv](file:///Users/i/dotfile/.zshenv) — Ekspor PATH, runtime variables (Node, Java, Go, Flutter, Bun), dieksekusi di seluruh invocations.
  - [.zprofile](file:///Users/i/dotfile/.zprofile) — Login shell bootstrap, auto-start `ssh-agent`, dan registrasi dinamis SSH keys (`~/.ssh/*.pub`).
  - [.zshrc](file:///Users/i/dotfile/.zshrc) — Konfigurasi interaktif, integrasi Oh My Zsh (tema Agnoster), custom alias git/flutter/lsd, dan fallback loader `~/.zshrc.secret`.
  - [.zshrc.secret.example](file:///Users/i/dotfile/.zshrc.secret.example) — Template token & kredensial rahasia lokal yang diabaikan git.
- **Dependencies**: Zsh, Oh My Zsh, OpenSSH (`ssh-agent`, `ssh-keygen`, `ssh-add`).
- **Consumers**: Login shell (Ghostty, iTerm2, SSH sessions, tmux panes).
- **External Integrations**: Homebrew, NVM, Composer, Maven, Flutter, Android SDK.
- **Key Notes**: Menggunakan pattern evaluasi berjenjang Zsh (`.zshenv` -> `.zprofile` -> `.zshrc`).

## Terminal & Multiplexer Configuration
- **Responsibility**: Antarmuka terminal emulator GPU-accelerated dan multiplexer sesi terminal.
- **Entry / Key Files**:
  - [config.ghostty](file:///Users/i/dotfile/config.ghostty) — Konfigurasi Ghostty (Font FiraCode Nerd Font, Ayu theme, background-opacity 0.90, cursor bar, Kitty Graphics Protocol passthrough support, fullscreen).
  - [.tmux.conf](file:///Users/i/dotfile/.tmux.conf) — Prefix `Ctrl+a`, mouse control, extended-keys (csi-u), truecolor RGB support, OSC 52 clipboard, dan passthrough image preview.
  - [ka-tmux/kanggara.tmux](file:///Users/i/dotfile/ka-tmux/kanggara.tmux) — Script loader tema status bar kustom tmux.
  - [ka-tmux/src/status-bar.conf](file:///Users/i/dotfile/ka-tmux/src/status-bar.conf) — Konfigurasi layout dan format status line tmux.
- **Dependencies**: Ghostty (macOS), Tmux 3.2+, Fira Code Nerd Font.
- **Consumers**: User interactive developer workflow.
- **External Integrations**: Kitty Graphics Protocol, terminal escape sequences (OSC 52, OSC 133).
- **Key Notes**: Tmux dikonfigurasi dengan `allow-passthrough on` dan `terminal-features ',xterm-ghostty:RGB:extkeys:sync:clipboard'` agar preview gambar dan clipboard OS tembus tanpa glitch.

## Neovim & Editor Suite
- **Responsibility**: Lingkungan text editor berbasis modal untuk software development.
- **Entry / Key Files**:
  - [nvim/init.lua](file:///Users/i/dotfile/nvim/init.lua) — Entry point konfigurasi Neovim.
  - [nvim/lua/chadrc.lua](file:///Users/i/dotfile/nvim/lua/chadrc.lua) — Konfigurasi NvChad kustom (UI, statusline, tabufline).
  - [nvim/lua/plugins/](file:///Users/i/dotfile/nvim/lua/plugins) — Manifest plugin Lazy.nvim.
  - [.vimrc](file:///Users/i/dotfile/.vimrc) — Konfigurasi minimalis Vim standar.
- **Dependencies**: Neovim 0.9+, Lua, Ripgrep, fd, Tree-sitter.
- **Consumers**: CLI code editing.
- **Key Notes**: Menggunakan arsitektur NvChad modular dengan Lazy.nvim package manager.

## Automations & System Setup
- **Responsibility**: Automasi provisioning dotfile, pembuatan symlink, dan instalasi software dasar OS.
- **Entry / Key Files**:
  - [install.sh](file:///Users/i/dotfile/install.sh) — Script instalasi otomatis dotfile utama (cross-platform macOS/Linux).
  - [setup/gitsetup.sh](file:///Users/i/dotfile/setup/gitsetup.sh) — Konfigurasi Git SSH commit signing dan global ignore.
  - [setup/docker.sh](file:///Users/i/dotfile/setup/docker.sh) — Provisioning Docker CE & Docker Compose di Debian/Ubuntu.
  - [pma.sh](file:///Users/i/dotfile/pma.sh) — Installer phpMyAdmin, Laravel Valet, dan MySQL di macOS.
  - [swap.sh](file:///Users/i/dotfile/swap.sh) — Kalkulator alokasi optimal swap Linux berbasis total RAM.
- **Dependencies**: Bash, curl, Homebrew, apt-get, Git.
- **Consumers**: Setup mesin baru atau sinkronisasi environment.
- **External Integrations**: GitHub, Homebrew Cask, Docker official apt repo.
- **Key Notes**: [install.sh](file:///Users/i/dotfile/install.sh) mengotomatisasi symlink ke `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.tmux.conf`, `~/.config/nvim`, dan Ghostty Library path di macOS.

## CI & Repository Quality
- **Responsibility**: Linting dan quality check otomatis untuk shell scripts.
- **Entry / Key Files**:
  - [.github/workflows/reviewdog.yaml](file:///Users/i/dotfile/.github/workflows/reviewdog.yaml) — GitHub Actions workflow menggunakan ShellCheck + reviewdog pada pull request.
- **Dependencies**: GitHub Actions runner, ShellCheck.
- **Consumers**: GitHub Pull Requests.
