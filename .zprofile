if [[ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "linux" ]] && [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
	if ! pgrep -u "$USER" ssh-agent >/dev/null; then
		eval "$(ssh-agent -s)"
	fi
fi
