#!/bin/bash
# KAnggara IntelliJ IDEA Launcher Setup
# url: https://github.com/KAnggara75/dotfile

set -eo pipefail

abort() {
	echo >&2 "[ERROR] $*"
	exit 1
}

# Determine target directory for the wrapper script
get_target_bin_dir() {
	if [ -n "${MY_BIN}" ]; then
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

main() {
	if [ "$(uname -s)" != "Darwin" ]; then
		abort "IntelliJ launcher script is intended for macOS."
	fi

	local app_path
	app_path="$(find_idea_app)" || abort "IntelliJ IDEA installation not found in /Applications, ~/Applications, or Spotlight."

	# If called with --setup or without arguments when launcher doesn't exist yet, install the wrapper
	if [ "$1" = "--setup" ]; then
		local bin_dir
		bin_dir="$(get_target_bin_dir)"
		mkdir -p "${bin_dir}"

		local target_script="${bin_dir}/idea"
		echo "==> Found IntelliJ IDEA at: ${app_path}"
		echo "==> Generating launcher script at: ${target_script}"

		cat <<EOF >"${target_script}"
#!/bin/sh
exec open -na "${app_path}" --args nosplash "\$@"
EOF

		chmod +x "${target_script}"
		echo "==> Done! You can now run 'idea <path>' from your terminal."
		return 0
	fi

	# Otherwise, directly open IntelliJ with all passed arguments
	exec open -na "${app_path}" --args nosplash "$@"
}

main "$@"
