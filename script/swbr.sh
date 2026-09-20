#!/usr/bin/env bash
# Script to switch default browser on macOS
# Usage:
#   swbr s  -> Safari
#   swbr e  -> Microsoft Edge
#   swbr c  -> Google Chrome

set -eo pipefail

check_installed() {
  local bundle_id="$1"
  local app_name="$2"

  local found_path
  found_path=$(mdfind "kMDItemCFBundleIdentifier == '$bundle_id'" 2>/dev/null | head -n 1)

  if [[ -z "$found_path" ]]; then
    echo "❌ Ditolak: $app_name tidak ditemukan / belum terinstall di sistem ini." >&2
    exit 1
  fi
}

get_current_bundle_id() {
  swift -e '
    import ApplicationServices
    import Foundation
    if let cur = LSCopyDefaultHandlerForURLScheme("http" as CFString)?.takeRetainedValue() as String? {
      print(cur)
    }
  ' 2>/dev/null
}

get_current_browser_name() {
  local cur
  cur=$(get_current_bundle_id)

  case "$cur" in
    *Safari*|*safari*) echo "Safari ($cur)" ;;
    *edgemac*|*Edge*|*edge*) echo "Microsoft Edge ($cur)" ;;
    *Chrome*|*chrome*) echo "Google Chrome ($cur)" ;;
    "") echo "Tidak diketahui" ;;
    *) echo "$cur" ;;
  esac
}

show_usage() {
  echo "Penggunaan: swbr [s|e|c]"
  echo "  s : Safari"
  echo "  e : Microsoft Edge"
  echo "  c : Google Chrome"
  echo ""
  echo "Browser default saat ini: $(get_current_browser_name)"
}

set_browser() {
  local bundle_id="$1"
  local app_name="$2"

  check_installed "$bundle_id" "$app_name"

  local current_id
  current_id=$(get_current_bundle_id | tr '[:upper:]' '[:lower:]')
  local target_id
  target_id=$(echo "$bundle_id" | tr '[:upper:]' '[:lower:]')

  if [[ "$current_id" == "$target_id" ]]; then
    echo "ℹ️  $app_name sudah menjadi default browser saat ini."
    exit 0
  fi

  # Cukup 1 kali pemanggilan skema 'http'.
  # Memanggil http + https sekaligus menyebabkan macOS memunculkan 2 popup konfirmasi.
  # Saat 'http' diubah, macOS secara otomatis menyinkronkan default web handler (termasuk https).
  swift -e "
    import ApplicationServices
    import Foundation
    let target = \"$bundle_id\" as CFString
    let status = LSSetDefaultHandlerForURLScheme(\"http\" as CFString, target)
    exit(status)
  " 2>/dev/null

  echo "✅ Default browser berhasil diarahkan ke $app_name."
}

main() {
  local target="$1"

  if [[ -z "$target" ]]; then
    show_usage
    exit 1
  fi

  case "$target" in
    s|safari)
      set_browser "com.apple.Safari" "Safari"
      ;;
    e|edge)
      set_browser "com.microsoft.edgemac" "Microsoft Edge"
      ;;
    c|chrome)
      set_browser "com.google.Chrome" "Google Chrome"
      ;;
    *)
      echo "❌ Argumen tidak dikenal: '$target'" >&2
      show_usage
      exit 1
      ;;
  esac
}

main "$@"
