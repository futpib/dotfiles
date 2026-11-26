
export ANDROID_HOME=~/Android/Sdk/

export PATH="$HOME/.cargo/bin:${ANDROID_HOME%/}/platform-tools:$HOME/.local/bin:$HOME/go/bin:$PATH"

source-env-if-exists () {
    [ -f "$1" ] || return 0
    set -o allexport
    source "$1" || return 1
    set +o allexport
}

source-env-if-exists ~/.env
source-env-if-exists ~/.env.local
