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

---

## ADR-008: Default Browser Switcher Utility (swbr)

- **Status**: Accepted
- **Date**: 2026-09-20
- **Source**: Codebase evidence (`script/swbr.sh`, `.zshrc`)
- **Context**: Developer sering perlu beralih browser default (Safari, Microsoft Edge, Google Chrome) untuk pengujian web dan alur kerja harian di macOS tanpa membuka antarmuka System Settings secara manual.
- **Decision**: Menambahkan utility script `script/swbr.sh` yang menggunakan AppleScript dan CoreServices LaunchServices configuration untuk mengubah browser default secara instan, serta mendaftarkan alias `swbr` di `.zshrc`.
- **Consequences**:
  - Pergantian default browser dapat dilakukan langsung dari CLI (`swbr s`, `swbr e`, `swbr c`).
  - Menggunakan direct CoreServices single HTTP handler untuk menghindari pop-up dialog konfirmasi ganda pada macOS.

---

## ADR-009: Tracking Template dan Isolasi .zsh_history via Skip-Worktree

- **Status**: Accepted
- **Date**: 2026-09-23
- **Source**: Codebase evidence (`.zsh_history`, `install.sh`)
- **Context**: File riwayat Zsh (`~/.zsh_history`) perlu dihubungkan (*symlinked*) ke repository dotfile agar terpusat, namun riwayat eksekusi command lokal pengguna tidak boleh terekspos atau membuat git status menjadi *dirty* setiap saat.
- **Decision**: Membuat file template kosong `.zsh_history` yang di-commit ke Git, lalu di-symlink ke `~/.zsh_history` via `install.sh`. Flag Git index `--skip-worktree` diterapkan pada file tersebut agar modifikasi riwayat lokal diabaikan sepenuhnya oleh Git tracking.
- **Consequences**:
  - File `.zsh_history` terkelola di dalam dotfile tanpa risiko commit command history harian secara tidak sengaja.
  - Perintah `install.sh` secara idempoten mengaplikasikan flag `git update-index --skip-worktree .zsh_history`.

---

## ADR-010: Integrasi Raycast Script Command dan Rotasi Otomatis Browser pada swbr

- **Status**: Accepted
- **Date**: 2026-10-02
- **Source**: Codebase evidence (`script/swbr.sh`, `install.sh`) & Developer interview
- **Context**: Pengguna ingin beralih browser default dengan cepat tanpa harus mengetik flag argumen (cukup menjalankan perintah langsung untuk berganti ke browser berikutnya) serta dapat dipicu langsung melalui launcher Raycast di macOS.
- **Decision**: Menambahkan metadata resmi Raycast Script Command (`@raycast.schemaVersion`, `@raycast.mode compact`, icon `🌐`, dan optional argument) ke `script/swbr.sh`. Jika dieksekusi tanpa parameter, script otomatis mendeteksi browser aktif dan merotasikannya ke kandidat berikutnya (Safari $\rightarrow$ Microsoft Edge $\rightarrow$ Google Chrome $\rightarrow$ Safari). Menambahkan symlink otomatis `~/.config/raycast/scripts/swbr.sh` dan binary `~/dev/bin/swbr` pada `install.sh`.
- **Consequences**:
  - Script dapat dipicu dari Raycast dengan shortcut/kata kunci "Switch Default Browser" maupun terminal (`swbr`).
  - Menekan Enter langsung di Raycast atau terminal akan merotasi browser secara otomatis tanpa prompt tambahan.

---

## ADR-011: DRY Work Navigation Helper (_gw) dan Resolusi Agility Tooling

- **Status**: Accepted
- **Date**: 2026-10-10
- **Source**: Codebase evidence (`.zshrc`, `.zshenv`) & Developer interview
- **Context**: Terdapat repetisi kode alias perpindahan direktori kerja (`cd $HOME/work/...`) serta kebutuhan menjalankan tool AI coding `agy -c` secara instan pada direktori yang dituju. Di samping itu, variabel lokal `path` pada implementasi awal menyebabkan variabel environment sistem `PATH` tertimpa karena sifat array-binding bawaan Zsh (`path` terikat ke `PATH`), yang sempat merusak eksekusi subshell statusline Antigravity.
- **Decision**:
  1. Mengonsolidasikan seluruh alias navigasi kerja ke dalam fungsi helper DRY `_gw()`.
  2. Menggunakan nama variabel lokal `local target_path="$1"` untuk menghindari interferensi dengan `PATH`.
  3. Menyediakan fallback bertingkat untuk resolusi binary `agy` (`command -v agy` $\rightarrow$ `~/.local/bin/agy` $\rightarrow$ `~/dev/bin/agy`).
  4. Menyelaraskan alias `locala` dan `aloc` untuk kompatibilitas plugin `you-should-use`.
- **Consequences**:
  - Konfigurasi `.zshrc` menjadi ringkas, terpusat, dan bebas duplikasi.
  - Nilai environment variable `PATH` tetap utuh dan stabil saat memanggil helper navigasi dengan parameter `-c`.

---

## ADR-012: Smart Multi-Tier Remote Podman Routing dan Isolasi Endpoint ke .zshrc.secret

- **Status**: Accepted
- **Date**: 2026-10-15
- **Source**: Codebase evidence (`.zshrc`, `.zshrc.secret.example`, `.zshrc.secret`) & Security audit
- **Context**: Workstation macOS membutuhkan koneksi Podman jarak jauh ke mesin server Linux/vivo untuk efisiensi CPU dan RAM. Koneksi dapat diakses melalui LAN lokal, Tailscale Linux, Tailscale Windows, atau fallback lokal. Menuliskan IP network dan Tailscale secara eksplisit di dalam file `.zshrc` publik menimbulkan risiko eksposur topologi jaringan internal ke git history.
- **Decision**:
  1. Mengimplementasikan fungsi pintar `p()` dengan *4-tier routing fallback* (LAN lokal $\rightarrow$ Tailscale Linux $\rightarrow$ Tailscale Windows $\rightarrow$ Local VM Mac).
  2. Memindahkan nilai IP network ke environment variables (`$VIVO_LOCAL_IP`, `$VIVO_TS_LINUX`, `$VIVO_TS_WIN`) yang disimpan secara terisolasi di `~/.zshrc.secret`.
  3. Menambahkan deklarasi `unalias p 2>/dev/null` sebelum fungsi `p()` untuk mencegah parse error akibat ekspansi alias lama.
  4. Menulis ulang riwayat git (*git filter-branch*) untuk membersihkan seluruh commit sebelumnya yang memuat alamat IP internal.
- **Consequences**:
  - Repositori publik sepenuhnya bersih dari alamat IP internal maupun endpoint Tailscale.
  - Alur eksekusi `podman` dan `docker` otomatis tersambung ke endpoint tercepat yang tersedia secara seamless.

---

## ADR-013: Deprekasi dan Penghapusan Script Installer phpMyAdmin (pma.sh)

- **Status**: Accepted
- **Date**: 2026-10-15
- **Source**: Developer request & Codebase evidence
- **Context**: Script installer otomatis phpMyAdmin, Laravel Valet, dan MySQL lokal macOS (`pma.sh`) sudah tidak relevan dengan alur kerja modern yang telah beralih ke containerization (Podman / Smocker / Docker). Mempertahankan script legacy tersebut menambah beban pemeliharaan dan potensi misleading pada dokumentasi repositori.
- **Decision**: Menghapus `pma.sh` secara permanen dari repositori dan memperbarui dokumentasi [README.md](file:///README.md), [CODEBASE_MAP.md](file:///.context/CODEBASE_MAP.md), serta [PROJECT_CONTEXT.md](file:///.context/PROJECT_CONTEXT.md).
- **Consequences**:
  - Repositori lebih bersih, terfokus pada utilitas aktif, dan bebas dari dependensi PHP/Valet legacy.
  - Dokumentasi [README.md](file:///README.md) kini mencerminkan toolset aktif (Ghostty terminal, `swbr` browser switcher, Podman 4-tier routing).

---

## ADR-014: Integrasi Verifikasi Sintaks Shell Otomatis Lokal (zsh -n dan shellcheck) ke Pre-Commit Hook

- **Status**: Accepted
- **Date**: 2026-10-15
- **Source**: Codebase evidence (`.githooks/pre-commit`) & Developer request
- **Context**: Kesalahan sintaks pada skrip shell (`.sh`, `.zsh`, `.zshrc`) sering kali baru terdeteksi setelah commit dibuat atau saat CI runner gagal di pull request. Mengandalkan linting remote memperlambat siklus iterasi dan berisiko merusak environment pengguna lokal jika script dengan syntax error ter-source.
- **Decision**: Menambahkan tahap validasi sintaks otomatis di [.githooks/pre-commit](file:///.githooks/pre-commit) dengan memanfaatkan `zsh -n` untuk semua file shell yang di-stage, serta pemeriksaan `shellcheck` lokal jika binary tersedia. Jika ditemukan syntax error, proses commit dibatalkan seketika dengan pesan deskriptif.
- **Consequences**:
  - Validasi sintaks terjadi instan dan lokal tanpa latency jaringan.
  - Mencegah syntax regression masuk ke git log.
  - Kompatibel dan graceful jika `shellcheck` belum terinstal (fallback tetap memvalidasi via `zsh -n`).

---

## ADR-015: Standardisasi Flag Dry-Run, Verifikasi Idempotensi, dan Modernisasi Script Setup & Swap

- **Status**: Accepted
- **Date**: 2026-10-15
- **Source**: Codebase evidence (`setup/*.sh`, `swap.sh`) & Developer request
- **Context**: Script utilitas di folder `setup/` (`docker.sh`, `fc.sh`, `gitsetup.sh`, `idea.sh`) dan `swap.sh` sebelumnya memiliki inkonsistensi perlakuan: beberapa melakukan instalasi tanpa memeriksa apakah komponen sudah terpasang (kurang idempoten), tidak memiliki opsi simulasi (`--dry-run`), dan kurang fleksibel dalam kustomisasi parameter.
- **Decision**:
  1. Menstandardisasi seluruh script di `setup/` dan `swap.sh` untuk menerima flag `-n` / `--dry-run` dan `-h` / `--help`.
  2. Menerapkan pemeriksaan precondition idempoten (contoh: mengecek binary `docker` terpasang, keberadaan font `FiraCode`, kecocokan signing key git, dan identitas script launcher `idea`).
  3. Memodernisasi `swap.sh` dengan opsi kustom ukuran (`-s, --size`), path (`-p, --path`), inspeksi status instan (`--status`), validasi ruang kosong disk (`df`), serta persistensi sysctl modular ke `/etc/sysctl.d/99-swap.conf`.
- **Consequences**:
  - Eksekusi skrip setup aman untuk dijalankan berulang kali tanpa efek samping negatif (*idempotent*).
  - Pengguna dapat memverifikasi aksi skrip secara simulatif sebelum mengeksekusi perubahan pada sistem operasi.

