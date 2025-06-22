# Di atas blok SSH agent
if [[ -z "$__SSH_AGENT_ALREADY_RUN" ]]; then
	export __SSH_AGENT_ALREADY_RUN=1

	SSH_ENV="$HOME/.ssh/agent-environment"
	function start_agent {
		eval "$(ssh-agent -s)" >/dev/null
		echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >"$SSH_ENV"
		echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >>"$SSH_ENV"
		chmod 600 "$SSH_ENV"
	}

	if [ -f "$SSH_ENV" ]; then
		. "$SSH_ENV"
		if ! kill -0 $SSH_AGENT_PID 2>/dev/null || [ ! -S "$SSH_AUTH_SOCK" ]; then
			start_agent
		fi
	else
		start_agent
	fi

	if ! ssh-add -l | grep -q "$(ssh-keygen -lf ~/.ssh/KAnggara75.pub | awk '{print $2}')" 2>/dev/null; then
		echo "Adding SSH key to agent..."
		[ -f ~/.ssh/KAnggara75 ] && ssh-add ~/.ssh/KAnggara75
	fi

fi

if [ "$(uname)" = "Darwin" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
