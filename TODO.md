# Project TODO & Technical Debt

## 1. Immediate Tasks
_Tugas atau perbaikan mendesak yang mempengaruhi reliability, correctness, atau security saat ini._
- [ ] `README.md`: Perbarui tabel dan dokumentasi terminal utama dari iTerm2 ke Ghostty serta jelaskan konfigurasi `config.ghostty`.

## 2. Existing Code Annotations (TODO / FIXME)
_Daftar TODO/FIXME yang tercantum langsung di dalam source code._
- *Tidak ditemukan annotation `TODO`, `FIXME`, `BUG`, atau `HACK` aktif di dalam source code saat ini.*

## 3. Technical Debt & Structural Improvements
_Pekerjaan arsitektural/refactoring jangka panjang untuk maintainability sistem._
- [x] ~~Evaluasi retensi `com.googlecode.iterm2.plist` dan file `.itermcolors`~~ *(Selesai: Dihapus permanen sesuai ADR-004)*.
- [ ] Standardisasi script di folder `setup/` agar konsisten mendukung flag dry-run dan verifikasi idempotensi.
- [ ] Tambahkan automated test/syntax check lokal (misal `make test` atau git pre-commit hook) sebelum push ke remote repository.
