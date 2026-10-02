#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Switch Default Browser
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🌐
# @raycast.argument1 { "type": "text", "placeholder": "s / e / c (opsional)", "optional": true }
# @raycast.packageName System Utilities

# Documentation:
# @raycast.description Switch default web browser on macOS between Safari, Edge, and Chrome. If no argument is provided, cycles to the next browser.
# @raycast.author KAnggara75

# Script to switch default browser on macOS
# Usage:
#   swbr        -> cycle ke browser berikutnya (Safari -> Edge -> Chrome -> Safari)
#   swbr s      -> Safari
#   swbr e      -> Microsoft Edge
#   swbr c      -> Google Chrome

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
  python3 -c "
import plistlib, os

plist_path = os.path.expanduser('~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist')
if not os.path.exists(plist_path):
    print('')
    exit(0)

try:
    with open(plist_path, 'rb') as f:
        data = plistlib.load(f)

    res = ''
    for h in data.get('LSHandlers', []):
        if h.get('LSHandlerContentType') == 'com.apple.default-app.web-browser':
            res = h.get('LSHandlerRoleAll', '')
            break
        if h.get('LSHandlerURLScheme') == 'http':
            res = h.get('LSHandlerRoleAll', '')

    print(res)
except Exception:
    print('')
" 2>/dev/null
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
  echo "  (tanpa argumen : beralih otomatis ke browser berikutnya)"
  echo ""
  echo "Browser default saat ini: $(get_current_browser_name)"
}

get_next_target() {
  local cur
  cur=$(get_current_bundle_id)

  local candidates=("s" "e")
  if mdfind "kMDItemCFBundleIdentifier == 'com.google.Chrome'" 2>/dev/null | grep -q app; then
    candidates+=("c")
  fi

  case "$cur" in
    *Safari*|*safari*)
      echo "e"
      ;;
    *edgemac*|*Edge*|*edge*)
      if [[ " ${candidates[*]} " =~ " c " ]]; then
        echo "c"
      else
        echo "s"
      fi
      ;;
    *Chrome*|*chrome*)
      echo "s"
      ;;
    *)
      echo "${candidates[0]}"
      ;;
  esac
}

set_browser() {
  local bundle_id="$1"
  local app_name="$2"

  check_installed "$bundle_id" "$app_name"

  local current_id
  current_id=$(get_current_bundle_id | tr '[:upper:]' '[:lower:]')
  local target_id
  target_id=$(echo "$bundle_id" | tr '[:upper:]' '[:lower:]')

  if [[ -n "$current_id" && "$current_id" == "$target_id" ]]; then
    echo "ℹ️  $app_name sudah menjadi default browser saat ini."
    exit 0
  fi

  # Gunakan Python ctypes langsung ke CoreServices macOS.
  # Hanya memanggil skema 'http' 1 kali saja.
  # Pemanggilan http + https terpisah (seperti pada tool 'defaultbrowser')
  # adalah penyebab utama munculnya 2 kali pop-up konfirmasi.
  python3 -c "
import ctypes, sys

cs = ctypes.cdll.LoadLibrary('/System/Library/Frameworks/CoreServices.framework/CoreServices')
cs.CFStringCreateWithCString.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_uint32]
cs.CFStringCreateWithCString.restype = ctypes.c_void_p
kCFStringEncodingUTF8 = 0x08000100

def to_cf(s):
    return cs.CFStringCreateWithCString(None, s.encode('utf-8'), kCFStringEncodingUTF8)

cs.LSSetDefaultHandlerForURLScheme.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
cs.LSSetDefaultHandlerForURLScheme.restype = ctypes.c_int32

scheme = to_cf('http')
handler = to_cf('$bundle_id')
ret = cs.LSSetDefaultHandlerForURLScheme(scheme, handler)
sys.exit(ret)
" 2>/dev/null

  echo "✅ Permintaan default browser ke $app_name telah dikirim (hanya 1 konfirmasi pop-up)."
}

main() {
  local target="$1"

  if [[ -z "$target" ]]; then
    target=$(get_next_target)
    echo "🔄 Berpindah dari $(get_current_browser_name) ke browser berikutnya..."
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
    -h|--help|help)
      show_usage
      exit 0
      ;;
    *)
      echo "❌ Argumen tidak dikenal: '$target'" >&2
      show_usage
      exit 1
      ;;
  esac
}

main "$@"
