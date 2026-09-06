# ----------------------------------------------------------------------------
# .zshenv - Always sourced for all Zsh invocations (interactive, non-interactive, scripts)
# Keep only environment variables and PATH here. NO aliases or interactive output.
# ----------------------------------------------------------------------------

# Basic Locale & Encoding
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Homebrew optimization
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_AUTO_UPDATE_SECS=86400

# Base Development Tools & Paths
export SBIN_PATH="/usr/local/sbin"
export RUBY_PATH="/opt/homebrew/opt/ruby"
export BUN_INSTALL="$HOME/.bun/bin"
export MY_BIN="$HOME/dev/bin"
export PODMAN_BUILD_BIN="$HOME/work/podman/scripts/build"
export WORK_BIN="/Users/Shared/dev/bin"

# Language SDKs & Runtimes
export COMPOSER_HOME="$HOME/.composer/vendor"
export CHROME_EXECUTABLE="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
export MAVEN_HOME="$HOME/dev/mvn/bin"
export ANDROID_HOME="/Users/Shared/android"
export FLUTTER_HOME="/Users/Shared/flutter/bin"
export MONGO_HOME="$HOME/dev/mongo/bin"
export GOPATH="/Users/Shared/go"
export GOMODCACHE="/Users/Shared/go/pkg/mod"
export GOCACHE="/Users/Shared/go-build-cache"
export AWS_DEFAULT_REGION="ap-southeast-3"
export MAVEN_OPTS="-Dmaven.repo.local=/Users/Shared/.m2/repository"
export PNPM_HOME="$HOME/Library/pnpm"
export CLAUDE_HOME="$HOME/.local/bin"
export GRALVM_HOME="$HOME/dev/openjdk/Contents/Home"
export BUN_BIN_DIR="/Users/Shared/.bun/bin/bin"

# OS Specific Environment
case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
darwin)
	export NVM_DIR="/Users/Shared/.nvm"
	export LIBPQ="/opt/homebrew/opt/libpq/bin"
	export MYSQL_CLIENT="/opt/homebrew/opt/mysql-client@8.4/bin"
	export PGPORT="5432"

	if [ -d "/Library/Java/JavaVirtualMachines/openjdk21/Contents/Home" ]; then
		export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk21/Contents/Home"
	elif command -v /usr/libexec/java_home >/dev/null 2>&1; then
		export JAVA_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null)
	fi

	export KOGITO_PERSISTENCE_TYPE="infinispan"
	export KOGITO_DATAINDEX_WS_URL="ws://localhost:8180"
	export KOGITO_DATAINDEX_HTTP_URL="http://localhost:8180"
	export KOGITO_FILE_PATH_SEPARATOR="/"
	export KOGITO_PERSISTENCE_DELETE_PROCESS_INSTANCE_ON_COMPLETION="true"

	export QUARKUS_INFINISPAN_CLIENT_HOSTS="localhost:11222"
	export QUARKUS_INFINISPAN_CLIENT_USE_AUTH="false"
	export QUARKUS_INFINISPAN_CLIENT_USERNAME="admin"
	export QUARKUS_INFINISPAN_CLIENT_PASSWORD="admin"
	export SMOCKER_PERSISTENCE_DIRECTORY="/Users/i/work/podman/smocker"

	# Fast native zsh glob for KUBECONFIG
	if [ -d "$HOME/work/kubeconfig" ]; then
		() {
			setopt localoptions extendedglob nullglob
			local _kube_configs=("$HOME/work/kubeconfig"/(^(*kafka-keystore-secret*|*ifgl-msk*)).yaml)
			export KUBECONFIG="${(j.:.)_kube_configs}"
		}
	fi
	;;
linux)
	export NVM_DIR="$HOME/.nvm"
	export KUBECONFIG="$HOME/.kube/config"
	export LIBPQ="/usr/local/opt/libpq/bin"
	export MYSQL_CLIENT="/usr/local/opt/mysql-client/bin"
	;;
esac

# Node compiler flags
export LDFLAGS="-L$NVM_DIR/versions/node/v22.16.0/lib"
export CPPFLAGS="-I$NVM_DIR/versions/node/v22.16.0/include"

# ----------------------------------------------------------------------------
# Clean, Deduplicated PATH Construction
# ----------------------------------------------------------------------------
typeset -U path

ZSH_PATHS=(
  "$MY_BIN"
  "$BUN_BIN_DIR"
  "$PODMAN_BUILD_BIN"
  "$WORK_BIN"
  "$GOPATH/bin"
  "$BUN_INSTALL"
  "$MONGO_HOME"
  "$LIBPQ"
  "$MYSQL_CLIENT"
  "$SBIN_PATH"
  "$RUBY_PATH"
  "$JAVA_HOME/bin"
  "$MAVEN_HOME"
  "$FLUTTER_HOME"
  "$COMPOSER_HOME/bin"
  "$COMPOSER_HOME/vendor/bin"
  "$ANDROID_HOME/cmdline-tools/latest/bin"
  "$ANDROID_HOME/platform-tools"
  "$NVM_DIR"
  "$PNPM_HOME"
  "$CLAUDE_HOME"
  "/Users/k/.antigravity/antigravity/bin"
  "/Users/k/.antigravity-ide/antigravity-ide/bin"
)

# Latest installed Node binary (fast instant node/npm availability)
if [ -d "$NVM_DIR/versions/node" ]; then
	() {
		setopt localoptions nullglob
		local _node_bins=("$NVM_DIR"/versions/node/*/bin(N))
		[ ${#_node_bins} -gt 0 ] && ZSH_PATHS=("${_node_bins[-1]}" "${ZSH_PATHS[@]}")
	}
fi

for d in $ZSH_PATHS; do
  [[ -d "$d" ]] && path+=("$d")
done

export PATH

# ----------------------------------------------------------------------------
# Sensitive / Local Secrets Loader
# ----------------------------------------------------------------------------
[[ -f "$HOME/.zshrc.secret" ]] && source "$HOME/.zshrc.secret"
[[ -f "${ZDOTDIR:-$HOME}/dotfile/.zshrc.secret" ]] && source "${ZDOTDIR:-$HOME}/dotfile/.zshrc.secret"
