# SSH agent management for Linux CLI
SSH_ENV="$HOME/.ssh/agent-environment"

# Function to start ssh-agent and save env vars
function start_agent {
	eval "$(ssh-agent -s)" >/dev/null
	echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >"$SSH_ENV"
	echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >>"$SSH_ENV"
	chmod 600 "$SSH_ENV"
}

# Jika file env ada, source dan cek agent masih hidup
if [ -f "$SSH_ENV" ]; then
	. "$SSH_ENV"
	if ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
		start_agent
	fi
else
	start_agent
fi

# Add key jika belum ada (ingat: gunakan private key, bukan .pub)
if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/KAnggara75.pub | awk '{print $2}')" 2>/dev/null; then
	[ -f ~/.ssh/KAnggara75 ] && ssh-add ~/.ssh/KAnggara75
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
