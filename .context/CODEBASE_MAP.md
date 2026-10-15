# Codebase Navigation Map

## Root Shell & Environment
- **Responsibility**: Mengelola bootstrap lifecycle shell Zsh, environment variable global, SSH agent, dan secret lokal.
- **Entry / Key Files**:
  - [.zshenv](file:///.zshenv) — Ekspor PATH, runtime variables (Node, Java, Go, Flutter, Bun), dieksekusi di seluruh invocations.
  - [.zprofile](file:///.zprofile) — Login shell bootstrap, auto-start `ssh-agent`, dan registrasi dinamis SSH keys (`~/.ssh/*.pub`).
  - [.zshrc](file:///.zshrc) — Konfigurasi interaktif, integrasi Oh My Zsh (tema Agnoster), custom alias git/flutter/lsd, helper navigasi kerja DRY `_gw()`, fungsi smart remote Podman `p()`, dan loader `~/.zshrc.secret`.
  - [.zshrc.secret.example](file:///.zshrc.secret.example) — Template token, kredensial, dan endpoint network privat ($VIVO_LOCAL_IP, $VIVO_TS_LINUX, $VIVO_TS_WIN) yang diabaikan git.
  - [.zsh_history](file:///.zsh_history) — Template file riwayat command Zsh yang dilindungi via `git update-index --skip-worktree`.
- **Dependencies**: Zsh, Oh My Zsh, OpenSSH (`ssh-agent`, `ssh-keygen`, `ssh-add`), Podman CLI, netcat (`nc`).
- **Consumers**: Login shell (Ghostty, SSH sessions, tmux panes).
- **External Integrations**: Homebrew, NVM, Composer, Maven, Flutter, Android SDK, Remote Linux/Tailscale host (vivo).
- **Key Notes**: Menggunakan pattern evaluasi berjenjang Zsh (`.zshenv` -> `.zprofile` -> `.zshrc`). Perubahan riwayat command lokal di `.zsh_history` tidak mengotori git index karena dilindungi skip-worktree. Menggunakan routing 4-tier otomatis untuk remote Podman execution.

## Terminal & Multiplexer Configuration
- **Responsibility**: Antarmuka terminal emulator GPU-accelerated dan multiplexer sesi terminal.
- **Entry / Key Files**:
  - [config.ghostty](file:///config.ghostty) — Konfigurasi Ghostty (Font FiraCode Nerd Font, Ayu theme, background-opacity 0.90, cursor bar, Kitty Graphics Protocol passthrough support, fullscreen).
  - [.tmux.conf](file:///.tmux.conf) — Prefix `Ctrl+a`, mouse control, extended-keys (csi-u), truecolor RGB support, OSC 52 clipboard, dan passthrough image preview.
  - [ka-tmux/kanggara.tmux](file:///ka-tmux/kanggara.tmux) — Script loader tema status bar kustom tmux.
  - [ka-tmux/src/status-bar.conf](file:///ka-tmux/src/status-bar.conf) — Konfigurasi layout dan format status line tmux.
  - [ka-tmux/scripts/battery.sh](file:///ka-tmux/scripts/battery.sh) — Script kalkulasi level persentase dan indikator charging baterai secara real-time.
- **Dependencies**: Ghostty (macOS), Tmux 3.2+, Fira Code Nerd Font.
- **Consumers**: User interactive developer workflow.
- **External Integrations**: Kitty Graphics Protocol, terminal escape sequences (OSC 52, OSC 133).
- **Key Notes**: Tmux dikonfigurasi dengan `allow-passthrough on` dan `terminal-features ',xterm-ghostty:RGB:extkeys:sync:clipboard'` agar preview gambar dan clipboard OS tembus tanpa glitch. Dilengkapi modul status baterai dinamis.

## Neovim & Editor Suite
- **Responsibility**: Lingkungan text editor berbasis modal untuk software development.
- **Entry / Key Files**:
  - [nvim/init.lua](file:///nvim/init.lua) — Entry point konfigurasi Neovim.
  - [nvim/lua/chadrc.lua](file:///nvim/lua/chadrc.lua) — Konfigurasi NvChad kustom (UI, statusline, tabufline).
  - [nvim/lua/plugins/](file:///nvim/lua/plugins) — Manifest plugin Lazy.nvim.
  - [.vimrc](file:///.vimrc) — Konfigurasi minimalis Vim standar.
- **Dependencies**: Neovim 0.9+, Lua, Ripgrep, fd, Tree-sitter.
- **Consumers**: CLI code editing.
- **Key Notes**: Menggunakan arsitektur NvChad modular dengan Lazy.nvim package manager.

## Automations & System Setup
- **Responsibility**: Automasi provisioning dotfile, pembuatan symlink, dan instalasi software dasar OS.
- **Entry / Key Files**:
  - [install.sh](file:///install.sh) — Script instalasi otomatis dotfile utama (cross-platform macOS/Linux).
  - [setup/gitsetup.sh](file:///setup/gitsetup.sh) — Konfigurasi Git SSH commit signing dan global ignore.
  - [setup/docker.sh](file:///setup/docker.sh) — Provisioning Docker CE & Docker Compose di Debian/Ubuntu.
  - [swap.sh](file:///swap.sh) — Kalkulator alokasi optimal swap Linux berbasis total RAM.
  - [script/swbr.sh](file:///script/swbr.sh) — Utility pengubah browser default macOS dan Raycast Script Command dengan rotasi otomatis (Safari $\rightarrow$ Edge $\rightarrow$ Chrome $\rightarrow$ Safari).
- **Dependencies**: Bash, curl, Homebrew, apt-get, Git, Python 3, osascript, Raycast.
- **Consumers**: CLI (`swbr`), Raycast Launcher, setup mesin baru atau sinkronisasi environment.
- **External Integrations**: GitHub, Homebrew Cask, Docker official apt repo, macOS CoreServices, Raycast Script Commands.
- **Key Notes**: [install.sh](file:///install.sh) mengotomatisasi symlink ke `~/.zshrc`, `~/.zshenv`, `~/.zprofile`, `~/.zsh_history`, `~/.tmux.conf`, `~/.config/nvim`, Ghostty Library path, binary `~/dev/bin/swbr`, dan folder `~/.config/raycast/scripts/`.

## CI & Repository Quality
- **Responsibility**: Linting dan quality check otomatis untuk shell scripts.
- **Entry / Key Files**:
  - [.github/workflows/reviewdog.yaml](file:///.github/workflows/reviewdog.yaml) — GitHub Actions workflow menggunakan ShellCheck + reviewdog pada pull request.
- **Dependencies**: GitHub Actions runner, ShellCheck.
- **Consumers**: GitHub Pull Requests.

## Security & Repository Protection
- **Responsibility**: Mencegah kebocoran rahasia (secret leak), token, dan private keys sebelum tersimpan ke riwayat git.
- **Entry / Key Files**:
  - [.githooks/pre-commit](file:///.githooks/pre-commit) — Pre-commit hook validator yang memblokir staging file sensitif dan konten berkredensial tinggi.
- **Dependencies**: Git, Bash, Python 3 (regex scanning).
- **Consumers**: `git commit` di local development.
- **Key Notes**: Dikonfigurasi otomatis melalui `core.hooksPath .githooks` di `install.sh`.

