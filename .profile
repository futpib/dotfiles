
export ANDROID_HOME=~/Android/Sdk/
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk-bundle"

export PATH="$HOME/.cargo/bin:$ANDROID_HOME/platform-tools/:$HOME/.local/bin/:$(cd && yarn --no-default-rc global bin --offline):$HOME/go/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$(realpath ~/.nvm)"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

which rbenv > /dev/null 2>&1 && eval "$(rbenv init - bash)"

source-env-if-exists () {
    [ -f "$1" ] || return 0
    set -o allexport
    source "$1" || return 1
    set +o allexport
}

source-env-if-exists ~/.env
source-env-if-exists ~/.env.local
