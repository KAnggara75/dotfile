#!/bin/bash
# KAnggara FiraCode Font Setup for macOS
# url: https://github.com/KAnggara75/dotfile

set -euo pipefail

DRY_RUN=0

usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install FiraCode fonts into ~/Library/Fonts on macOS.

Options:
  -n, --dry-run  Simulate actions without downloading or installing fonts
  -h, --help     Show this help message
EOF
}

abort() {
	printf "%s\n" "$@" >&2
	exit 1
}

log() {
	printf "==> %s\n" "$*"
}

run_cmd() {
	if [ "${DRY_RUN}" -eq 1 ]; then
		printf "[DRY-RUN] %s\n" "$*"
	else
		"$@"
	fi
}

get_url() {
	local release_url
	release_url="$(curl -s https://api.github.com/repos/tonsky/FiraCode/releases/latest |
		grep "browser_download_url.*zip" |
		cut -d : -f 2,3 |
		tr -d ' "')"

	if [ -z "${release_url}" ]; then
		abort "Failed to resolve latest FiraCode release zip URL."
	fi

	if command -v curl >/dev/null 2>&1; then
		curl -fsSL "${release_url}"
	else
		wget -qO- "${release_url}"
	fi
}

install_fonts() {
	local font_dir="${HOME}/Library/Fonts"
	mkdir -p "${font_dir}"

	if [ "${DRY_RUN}" -eq 1 ]; then
		log "Would fetch latest FiraCode zip release and extract TTF files into ${font_dir}"
		log "Would remove unneeded webfont and variable font formats (.woff, .woff2, -VF.ttf)"
		return 0
	fi

	local tmp_dir
	tmp_dir="$(mktemp -d)"
	trap 'rm -rf "${tmp_dir}"' EXIT

	log "Downloading and extracting FiraCode archive..."
	get_url > "${tmp_dir}/firacode.zip"
	unzip -q -o "${tmp_dir}/firacode.zip" -d "${tmp_dir}/extracted"

	if [ -d "${tmp_dir}/extracted/ttf" ]; then
		cp -f "${tmp_dir}/extracted/ttf/"*.ttf "${font_dir}/"
	elif compgen -G "${tmp_dir}/extracted/*.ttf" >/dev/null; then
		cp -f "${tmp_dir}/extracted/"*.ttf "${font_dir}/"
	fi

	# Clean up any non-standard or unwanted variations if extracted
	rm -f "${font_dir}"/FiraCode-*.woff "${font_dir}"/FiraCode-*.woff2 "${font_dir}"/FiraCode-VF.ttf 2>/dev/null || true
	log "FiraCode fonts installed successfully."
}

main() {
	while [ $# -gt 0 ]; do
		case "$1" in
		-n | --dry-run)
			DRY_RUN=1
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		*)
			abort "Unknown option: $1 (run with -h/--help for usage)"
			;;
		esac
	done

	if [ "$(uname -s)" != "Darwin" ]; then
		abort "FiraCode setup script is intended for macOS."
	fi

	export LC_CTYPE="en_US.UTF-8"

	# Check if fontconfig is installed, offer or run if needed
	if ! command -v fc-list >/dev/null 2>&1; then
		log "fontconfig (fc-list) not found. Installing via Homebrew..."
		run_cmd brew install fontconfig
	fi

	# Idempotency check: see if FiraCode is already present in fontconfig or in ~/Library/Fonts
	if (command -v fc-list >/dev/null 2>&1 && fc-list : family | grep -q "Fira Code") || compgen -G "${HOME}/Library/Fonts/FiraCode-*.ttf" >/dev/null; then
		log "FiraCode font is already installed."
		if [ "${DRY_RUN}" -eq 1 ]; then
			log "Dry-run check: No changes needed."
		fi
		return 0
	fi

	log "FiraCode not detected. Installing..."
	install_fonts
}

main "$@"
