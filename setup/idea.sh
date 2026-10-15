#!/bin/bash
# KAnggara IntelliJ IDEA Launcher Setup
# url: https://github.com/KAnggara75/dotfile

set -eo pipefail

DRY_RUN=0

usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS] [FILES_OR_DIRS...]

IntelliJ IDEA CLI Launcher & Wrapper Setup for macOS.

Options:
  --setup        Install/update the 'idea' wrapper script in your binary path
  -n, --dry-run  Simulate actions without modifying files or launching IntelliJ
  -h, --help     Show this help message

Examples:
  $(basename "$0") --setup             Install the launcher wrapper to bin directory
  $(basename "$0") --setup --dry-run   Simulate wrapper script generation
  $(basename "$0") .                   Open current directory in IntelliJ IDEA
EOF
}

abort() {
	echo >&2 "[ERROR] $*"
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

# Determine target directory for the wrapper script
get_target_bin_dir() {
	if [ -n "${MY_BIN:-}" ]; then
		echo "${MY_BIN}"
	elif [ -d "${HOME}/.local/bin" ]; then
		echo "${HOME}/.local/bin"
	elif [ -d "${HOME}/bin" ]; then
		echo "${HOME}/bin"
	else
		echo "${HOME}/dev/bin"
	fi
}

find_idea_app() {
	local candidates=(
		"/Applications/IntelliJ IDEA.app"
		"${HOME}/Applications/IntelliJ IDEA.app"
		"/Applications/IntelliJ IDEA Ultimate.app"
		"${HOME}/Applications/IntelliJ IDEA Ultimate.app"
		"/Applications/IntelliJ IDEA CE.app"
		"${HOME}/Applications/IntelliJ IDEA CE.app"
		"/Applications/IntelliJ IDEA Community Edition.app"
		"${HOME}/Applications/IntelliJ IDEA Community Edition.app"
	)

	for app in "${candidates[@]}"; do
		if [ -d "${app}" ]; then
			echo "${app}"
			return 0
		fi
	done

	# Fallback search via Spotlight metadata
	if command -v mdfind >/dev/null 2>&1; then
		local found
		found=$(mdfind "kMDItemCFBundleIdentifier == 'com.jetbrains.intellij*'" 2>/dev/null | head -n 1)
		if [ -n "${found}" ] && [ -d "${found}" ]; then
			echo "${found}"
			return 0
		fi
	fi

	return 1
}

setup_launcher() {
	local app_path="$1"
	local bin_dir
	bin_dir="$(get_target_bin_dir)"
	local target_script="${bin_dir}/idea"

	log "Found IntelliJ IDEA at: ${app_path}"
	log "Target launcher script path: ${target_script}"

	local script_content
	script_content="#!/bin/sh
exec open -na \"${app_path}\" --args nosplash \"\$@\"
"

	if [ -f "${target_script}" ] && [ "$(cat "${target_script}")" = "${script_content}" ]; then
		log "Launcher script at '${target_script}' is already up-to-date."
		if [ "${DRY_RUN}" -eq 1 ]; then
			log "Dry-run check: No changes needed."
		fi
		return 0
	fi

	if [ "${DRY_RUN}" -eq 1 ]; then
		log "Would create directory: ${bin_dir}"
		log "Would write launcher script: ${target_script}"
		log "Content:"
		printf "%s\n" "${script_content}"
		return 0
	fi

	mkdir -p "${bin_dir}"
	printf "%s" "${script_content}" >"${target_script}"
	chmod +x "${target_script}"
	log "Done! You can now run 'idea <path>' from your terminal."
}

main() {
	local is_setup=0
	local launch_args=()

	while [ $# -gt 0 ]; do
		case "$1" in
		--setup)
			is_setup=1
			shift
			;;
		-n | --dry-run)
			DRY_RUN=1
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		*)
			launch_args+=("$1")
			shift
			;;
		esac
	done

	if [ "$(uname -s)" != "Darwin" ]; then
		abort "IntelliJ launcher script is intended for macOS."
	fi

	local app_path
	app_path="$(find_idea_app)" || abort "IntelliJ IDEA installation not found in /Applications, ~/Applications, or Spotlight."

	# Setup mode
	if [ "${is_setup}" -eq 1 ]; then
		setup_launcher "${app_path}"
		return 0
	fi

	# Dry-run for opening IDEA
	if [ "${DRY_RUN}" -eq 1 ]; then
		log "Dry-run: Would launch IntelliJ IDEA at '${app_path}' with args: ${launch_args[*]:-(none)}"
		printf "[DRY-RUN] open -na \"%s\" --args nosplash %s\n" "${app_path}" "${launch_args[*]}"
		return 0
	fi

	# Directly open IntelliJ with all passed arguments
	exec open -na "${app_path}" --args nosplash "${launch_args[@]}"
}

main "$@"
