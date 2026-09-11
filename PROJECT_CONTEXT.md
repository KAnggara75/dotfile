# Project Context

## Project Purpose
Menyediakan lingkungan pengembangan software yang terstandardisasi, terautomasi, dan konsisten di berbagai mesin (khususnya macOS dan Linux). Repositori ini mengelola konfigurasi shell Zsh berkinerja tinggi, terminal emulator modern (Ghostty), terminal multiplexer (Tmux), modal text editor (Neovim/NvChad), serta rangkaian script automasi deployment dan utilitas lokal.

## System Boundary
- **Dalam Cakupan (In Scope)**:
  - Dotfiles shell (`.zshenv`, `.zprofile`, `.zshrc`, `.vimrc`).
  - Terminal configs ([config.ghostty](file:///Users/i/dotfile/config.ghostty), [.tmux.conf](file:///Users/i/dotfile/.tmux.conf), [ka-tmux/](file:///Users/i/dotfile/ka-tmux)).
  - Editor config ([nvim/](file:///Users/i/dotfile/nvim)).
  - Script instalasi otomatis sistem dan symlink provisioning ([install.sh](file:///Users/i/dotfile/install.sh)).
  - Helper scripts setup development tooling ([setup/](file:///Users/i/dotfile/setup), [pma.sh](file:///Users/i/dotfile/pma.sh), [swap.sh](file:///Users/i/dotfile/swap.sh)).
- **Di Luar Cakupan (Out of Scope)**:
  - Manajemen rahasia pribadi dan kredensial (didelegasikan ke `~/.zshrc.secret` dan `~/.ssh/`).
  - Manajemen lisensi OS atau software pihak ketiga berbayar.
  - Source code aplikasi proyek bisnis pengguna.

## Main Actors
- **Primary Developer (`i` / `KAnggara`)**: Pengembang utama yang menggunakan dotfile ini sehari-hari di macOS dan Linux.
- **Automated Installer (`install.sh`)**: Script runner yang dijalankan saat bootstrap mesin baru.
- **CI Runner (`GitHub Actions / reviewdog`)**: Menjalankan linting `shellcheck` pada setiap Pull Request.

## Important Domain Concepts & Glossary
- **Hierarchical Sourcing**: Pola urutan pembacaan konfigurasi Zsh: `.zshenv` (global/scripts) $\rightarrow$ `.zprofile` (login session) $\rightarrow$ `.zshrc` (interactive terminal).
- **Terminal Multiplexer Passthrough**: Mekanisme bypass kontrol escape sequence di Tmux (`allow-passthrough on`) agar fitur grafis/OSC Ghostty tembus ke shell.
- **Dynamic SSH Keyring**: Logika di `.zprofile` yang secara otomatis mengenali dan mendaftarkan pasangan kunci `.pub` di folder `~/.ssh/` ke `ssh-agent`.

## External Systems
- **Homebrew**: Package manager utama di macOS untuk CLI tools, fonts, dan aplikasi Cask.
- **GitHub**: Repository hosting, remote origin, dan CI runner target.
- **Ghostty Ecosystem**: Terminal emulator GPU native yang membaca konfigurasi dari `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`.

## Runtime Environment & Constraints
- **Operating Systems**: macOS (Primary, Apple Silicon `/opt/homebrew`), Linux (Secondary, Debian/Ubuntu apt-get).
- **Default Shell**: Zsh 5.x+ dengan Oh My Zsh.
- **Security Constraint**: Tidak boleh ada private key, API token, atau password yang di-commit ke Git tracking.

## Coding Conventions & Standards
- Shell Scripting: Validasi terhadap ShellCheck via GitHub Actions.
- Formatters: EditorConfig (`.editorconfig`) untuk indentasi dan newline.
- Lua: Stylua (`nvim/.stylua.toml`) untuk pemformatan script konfigurasi Neovim.

## Platform-Specific Scope
- **Ghostty**: Digunakan secara eksklusif di macOS. Pada Linux, environment terminal mengandalkan default terminal emulator bawaan distro yang langsung menjalankan Tmux / Zsh tanpa dependensi Ghostty.
