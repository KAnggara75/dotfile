# Jalankan hanya di Linux DAN hanya jika session SSH
if [[ "$(uname -s | tr '[:upper:]' '[:lower:]')" == "linux" ]] && [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
	# Start ssh-agent jika belum ada
	if ! pgrep -u "$USER" ssh-agent >/dev/null; then
		eval "$(ssh-agent -s)"
	fi

	# Gunakan file private key (tanpa .pub)
	if [ -f ~/.ssh/KAnggara75 ]; then
		if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/KAnggara75.pub | awk '{print $2}')" 2>/dev/null; then
			ssh-add ~/.ssh/KAnggara75
		fi
	fi
fi
