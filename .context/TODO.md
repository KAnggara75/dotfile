# Project TODO & Technical Debt

## 1. Immediate Tasks
_Tugas atau perbaikan mendesak yang mempengaruhi reliability, correctness, atau security saat ini._
- [x] ~~`README.md`: Perbarui tabel dan dokumentasi terminal utama dari iTerm2 ke Ghostty serta jelaskan konfigurasi `config.ghostty`~~ *(Selesai: Diperbarui dengan Ghostty, Ayu theme, dan swbr)*.
- [x] ~~Hapus script legacy `pma.sh` dan sinkronkan referensi dokumentasi~~ *(Selesai: Dihapus via ADR-013)*.
- [x] ~~Push rewrite history lokal ke remote origin~~ *(Selesai: Force push origin main tersinkron)*.

## 2. Existing Code Annotations (TODO / FIXME)
_Daftar TODO/FIXME yang tercantum langsung di dalam source code._
- *Tidak ditemukan annotation `TODO`, `FIXME`, `BUG`, atau `HACK` aktif di dalam source code saat ini.*

## 3. Technical Debt & Structural Improvements
_Pekerjaan arsitektural/refactoring jangka panjang untuk maintainability sistem._
- [x] ~~Evaluasi retensi `com.googlecode.iterm2.plist` dan file `.itermcolors`~~ *(Selesai: Dihapus permanen sesuai ADR-004)*.
- [x] ~~Integrasi git pre-commit hook untuk pencegahan kebocoran secret lokal~~ *(Selesai: Diaktifkan di `.githooks/pre-commit` sesuai ADR-006)*.
- [x] ~~Sentralisasi baseline memory dan dokumentasi arsitektur ke `.context/`~~ *(Selesai: Dimigrasikan via skill `ka-context`)*.
- [ ] Standardisasi script di folder `setup/` agar konsisten mendukung flag dry-run dan verifikasi idempotensi.
- [ ] Tambahkan verifikasi syntax check shell otomatis lokal (misal `zsh -n` dan `shellcheck`) ke dalam pre-commit hook sebelum commit dibuat.
