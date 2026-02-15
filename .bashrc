
HISTFILE=~/.histfile
HISTCONTROL=ignoreboth
HISTSIZE=10000
SAVEHIST=10000

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -f /etc/gentoo-release ]
then
    alias i="sudo emerge"
    alias 1="sudo emerge --oneshot"
    alias r="sudo emerge -C"
    alias f='emerge --search'
else
    alias i="sudo pacman -S"
    alias r="sudo pacman -R"
    alias f='pacman -Ss'
fi
alias s='sudo'
alias v='sudo vim'

# sudo autocomlete
complete -cf s sudo kdesu man exec which whereis xargs

source ~/.profile

source-env () {
    set -o allexport
    source "$1" || return 1
    set +o allexport
}

if echo "$-" | grep i > /dev/null; then
    source ~/.bash_colors
    # PS stuff
    __replicate () {
        printf "%*s" "$2" "" | sed "s| |$1|g"
    }

    __displaytime () {
        local T=$1
        local D=$((T/60/60/24))
        local H=$((T/60/60%24))
        local M=$((T/60%60))
        local S=$((T%60))
        [[ $D > 0 ]] && printf '%dd ' $D
        [[ $H > 0 ]] && printf '%dh ' $H
        [[ $M > 0 ]] && printf '%dm ' $M
        #   [[ $D > 0 || $H > 0 || $M > 0 ]] && printf 'and '
        printf '%ds\n' $S
    }

    __print_part_in_brackets () {
        local protocol=''
        if [ -n "${SSH_TTY}" ]; then
            protocol="${protocol}${Purple}ssh${Color_Off}${IBlack}://${Color_Off}"
        fi

        local git_root="$(git rev-parse --show-toplevel 2> /dev/null)"

        local pwd="$PWD"
        if [[ "${git_root}" != "" ]]
        then
            pwd="$(echo ${pwd} | sed "s|${git_root}|${UWhite_Escaped}\0${Color_Off_Escaped}|")"
        fi
        pwd="$(echo ${pwd} | sed "s|$HOME|~|")"

        printf "${protocol}${Green}${USER}${IBlack}@$(uname -n)${Color_Off} ${pwd}${IBlack}"
    }

    __nvm_use_last_pwd=""
    __nvm_use () {
        if [[ "$PWD" != "$__nvm_use_last_pwd" && ( -f ".nvmrc" || -f "package.json" ) ]]; then
            __nvm_use_last_pwd="$PWD"
            local package_json_version="$(nvm-package-json-node-version)"
            if [[ "${package_json_version}" != "" ]]; then
                nvm use "${package_json_version}"
            elif [[ -f ".nvmrc" ]]; then
                nvm use
            fi
        fi
    }

    __refresh_history () {
        history -a
        history -c
        history -r
    }

    __hr () { # __hr left_text right_text line_color
    #     printf "$1"'%*s\n' "$(($(tput cols) - ${#1}))" "$2" | sed 's/ /—/g';
    # 1 for text at left
    # 2 for text at right
    # 3 for setting line color
    #     printf "$3\r"
    #     printf "%*s\r" "$(tput cols)" "${Color_Off}${2}" | sed 'y/ _/— /'
    #     printf "${Color_Off}\r"
    #     printf "$1\n"
        
        local r_noescape="$( echo ""$2"" | sed -E 's#\e\[([0-9];)?[0-9]+m##g' )"
        local rlen="${#r_noescape}"
        
        printf "\r$3"
        printf '%*s' "$(tput cols)" '' | sed 's/ /─/g'
        printf "$(__replicate '\\b' $(($rlen - 1)))"
        printf "${Color_Off}$2\r${Color_Off}$1${Color_Off}\n"
    }

    __bash_timer_file="${XDG_RUNTIME_DIR:-/tmp}/.bash_timer_$$"
    trap 'rm -f "$__bash_timer_file"' EXIT

    __ps0_preexec () {
        date '+%s' > "$__bash_timer_file"
        __hr " ${IBlack}started at [$(date '+%H:%M:%S')]${Color_Off} "\
            ""\
            "${Blue}"
    }

    __prompt_command () {
        local returned=$?

        if [[ ! -f "$__bash_timer_file" ]]; then
            return
        fi

        local last_started
        last_started=$(<"$__bash_timer_file")
        rm -f "$__bash_timer_file"

        if [[ $returned -gt 0 ]]; then
            local returned_full="${Color_Off} error $returned "
            local returned_hr_color="${Red}"
        else
            local returned_full="${IBlack} successfully "
            local returned_hr_color="${Green}"
        fi

        local important_vars=''
        if [ -n "${WINEARCH}" ]; then
            important_vars="${important_vars}wine: ${WINEARCH} "
        fi
        if [ -n "${WINEPREFIX}" ]; then
            important_vars="${important_vars}prefix: \"${WINEPREFIX/$HOME/~}\" "
        fi
        if [ -n "${DOCKER_CONTEXT}" ]; then
            important_vars="${important_vars}context: ${DOCKER_CONTEXT} "
        fi
        local netns="$(ip netns identify)"
        if [ -n "${netns}" ]; then
            important_vars="${important_vars}netns: ${netns} "
        fi

        local spent
        spent="$(__displaytime $(( $(date '+%s') - last_started )))"

        __nvm_use

        printf "${BWhite}${On_Red}↵${Color_Off}\n"
        __hr "${IBlack}finished at [$(date '+%H:%M:%S')] (took $spent) [$(__print_part_in_brackets)] ${important_vars}"\
            "${returned_full}"\
            "${returned_hr_color}"
    }

    PROMPT_COMMAND='__prompt_command'
    PS0='$(__ps0_preexec)\n'

    __nvm_use

    __hr "${IBlack}[$(date '+%H:%M:%S')] [$(__print_part_in_brackets)] "\
        "${IBlack} bash $BASH_VERSION "\
        "${IBlack}"

fi


# PS1="${IBlack}[\t]${Color_Off}[${BGreen}\u${Color_Off}@\h \w]\$ "
# PS1="[${BGreen}\u${Color_Off}@\h \w]\$ "
# PS1="\$ "
PS1="→ "
PS2=" → "
PS3="  → "
PS4="   → "
