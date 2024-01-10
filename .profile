
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# https://github.com/xmonad/xmonad/issues/126
export _JAVA_AWT_WM_NONREPARENTING=1

export ANDROID_HOME=~/Android/Sdk/
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk-bundle"

export PATH="$HOME/.cargo/bin:$ANDROID_HOME/platform-tools/:$HOME/.local/bin/:$(yarn --no-default-rc global bin --offline):$HOME/go/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export ERL_AFLAGS="-kernel shell_history enabled"

export NVM_DIR="$(realpath ~/.nvm)"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
