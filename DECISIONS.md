# Architecture Decision Records (ADR)

Dokumen ini bersifat **append-only**. Keputusan baru ditambahkan secara berurutan tanpa menimpa keputusan sebelumnya.

---

## ADR-001: Penggunaan Ghostty sebagai Terminal Emulator Utama

- **Status**: Accepted
- **Date**: 2026-09-11
- **Source**: Codebase evidence & developer direction
- **Context**: Sebelumnya repositori mengandalkan iTerm2 via `com.googlecode.iterm2.plist` dan `iterm_check` pada `install.sh`. Dibutuhkan terminal emulator modern yang lebih cepat (GPU-accelerated), memiliki rendering teks tajam, dan mendukung standar modern seperti Kitty Graphics Protocol secara native.
- **Decision**: Mengadopsi Ghostty sebagai terminal emulator primer. Konfigurasi disimpan di `config.ghostty` di root repository dan di-symlink ke `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`. Fungsi `iterm_check` di `install.sh` digantikan dengan `ghostty_check`.
- **Consequences**:
  - Konfigurasi terminal menjadi berbasis teks deklaratif yang mudah dilacak di git.
  - Performa rendering terminal meningkat signifikan.
  - File iTerm2 plist dipertahankan sebagai referensi backup namun instalasi otomatis beralih ke Ghostty.

---

## ADR-002: Passthrough Kitty Graphics Protocol dan TrueColor pada Tmux

- **Status**: Accepted
- **Date**: 2026-09-11
- **Source**: Codebase evidence (.tmux.conf)
- **Context**: Sesi Tmux secara default mencegat (*intercept*) escape sequences, sehingga fitur lanjutan Ghostty (seperti preview gambar via Kitty Graphics Protocol dan sinkronisasi clipboard OSC 52) terblokir saat berada di dalam Tmux.
- **Decision**: Mengaktifkan `allow-passthrough on`, `set-clipboard on`, serta menambahkan spesifikasi `terminal-features ",xterm-ghostty:RGB:extkeys:sync:clipboard"` dan default terminal `tmux-256color` pada `.tmux.conf`.
- **Consequences**:
  - Aplikasi CLI/TUI modern (seperti `yazi`, Neovim `image.nvim`, `viu`) dapat menampilkan gambar dan memanfaatkan clipboard sistem di dalam Tmux tanpa hambatan.
  - Memerlukan versi Tmux modern (3.2+).

---

## ADR-003: Dynamic SSH Key Discovery di .zprofile

- **Status**: Accepted
- **Date**: 2026-09-10
- **Source**: Codebase evidence (.zprofile)
- **Context**: Sebelumnya pendaftaran kunci SSH ke `ssh-agent` ditulis secara manual per file kunci (misal `KAnggara75`, `ProgrammerMode`). Menambahkan kunci baru (seperti `IFG` atau akun lain) mengharuskan pengeditan manual berulang.
- **Decision**: Mengubah skema pendaftaran kunci SSH di `.zprofile` menjadi iterasi dinamis untuk seluruh file `~/.ssh/*.pub`. Script memvalidasi keberadaan private key dan mencocokkan fingerprint terhadap `ssh-add -l` sebelum mendaftarkannya.
- **Consequences**:
  - Penambahan atau penghapusan kunci SSH di `~/.ssh/` otomatis terakomodasi tanpa perlu mengubah `.zprofile`.
  - Waktu startup login shell tetap efisien karena kunci yang sudah terdaftar tidak ditambahkan ulang.

---

## ADR-004: Penghapusan Total Konfigurasi Legacy iTerm2

- **Status**: Accepted
- **Date**: 2026-09-11
- **Source**: Developer interview
- **Context**: Migrasi ke Ghostty telah selesai dan konfigurasi telah stabil. File binary plist (`com.googlecode.iterm2.plist`) dan profil warna (`AtomOneDark.itermcolors`, `ayu.itermcolors`) tidak lagi digunakan.
- **Decision**: Menghapus seluruh file konfigurasi dan palet warna iTerm2 dari repositori.
- **Consequences**:
  - Repositori menjadi lebih bersih, ringan, dan bebas dari artefak binary plist yang sulit di-diff di Git.

---

## ADR-005: Penegasan Batasan Platform Ghostty Khusus macOS

- **Status**: Accepted
- **Date**: 2026-09-11
- **Source**: Developer interview
- **Context**: Lingkungan pengembangan mencakup macOS dan Linux. Diperlukan kejelasan apakah Ghostty perlu didukung/diinstal pada lingkungan Linux.
- **Decision**: Menetapkan Ghostty sebagai terminal emulator eksklusif untuk lingkungan macOS. Pada Linux, dotfile tidak menggunakan Ghostty dan hanya mengelola layer shell (Zsh), Tmux, dan Neovim.
- **Consequences**:
  - `install.sh` menjaga `ghostty_check` hanya dieksekusi saat platform terdeteksi sebagai macOS.
  - Tidak ada overhead memelihara dependensi atau package builder Ghostty untuk Linux.

---

## ADR-006: Integrasi Pre-Commit Security Hook untuk Secret Leak Prevention

- **Status**: Accepted
- **Date**: 2026-09-13
- **Source**: Codebase evidence (`.githooks/pre-commit`, `install.sh`)
- **Context**: Sebagai dotfile publik, risiko tidak sengaja melakukan commit terhadap token, file kredensial privat (`.env`, `id_rsa`, `.zshrc.secret`), atau API keys sangat fatal.
- **Decision**: Mengimplementasikan pre-commit hook berbasis script di `.githooks/pre-commit` yang memindai pola file sensitif dan regex entropy/tokens pada staged changes. Repositori mengonfigurasi `core.hooksPath .githooks`, yang juga otomatis diaktifkan via `install.sh`.
- **Consequences**:
  - Semua commit lokal otomatis diverifikasi keamanannya sebelum tersimpan ke riwayat git.
  - Mengabaikan file `.example` secara otomatis agar template tetap dapat di-commit.

---

## ADR-007: Modul Status Baterai Dinamis pada ka-tmux

- **Status**: Accepted
- **Date**: 2026-09-13
- **Source**: Codebase evidence (`ka-tmux/scripts/battery.sh`, `ka-tmux/src/status-bar.conf`)
- **Context**: Pengguna membutuhkan visibilitas persentase daya dan status pengisian baterai laptop secara real-time langsung di statusline Tmux tanpa dependensi berat.
- **Decision**: Membuat script `ka-tmux/scripts/battery.sh` yang mengekstrak status baterai secara native via `pmset` (macOS) atau `/sys/class/power_supply` (Linux) dengan ikon indikator dinamis berbasis level persentase dan status charging, lalu menyematkannya ke `status-right`.
- **Consequences**:
  - Status baterai terlihat jelas di seluruh window/pane Tmux.
  - Kompatibel lintas platform macOS dan Linux tanpa membutuhkan runtime eksternal selain Bash standar.
