
HISTFILE=~/.histfile
HISTCONTROL=ignoreboth
HISTSIZE=10000
SAVEHIST=10000

export GREP_COLOR='1;33'

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -f /etc/gentoo-release ]
then
    alias i="sudo emerge"
    alias 1="sudo emerge --oneshot"
    alias r="sudo emerge -C"
    alias f='emerge --search'
elif [ -f /usr/bin/yaourt ]
then
    alias i="yaourt -S"
    alias r="yaourt -R"
    alias f='yaourt -Ss'
else
    alias i="sudo pacman -S"
    alias r="sudo pacman -R"
    alias f='pacman -Ss'
fi
alias p="ping google.com"
alias s='sudo'
#alias d='sudo dolphin'
#alias k='sudo kate'
alias n='sudo nano'
alias v='sudo vim'
alias g='grep'

# alias m='mpdc'

# sudo autocomlite
complete -cf s sudo kdesu man exec which whereis xargs

source ~/.profile


if echo "$-" | grep i > /dev/null; then
    source ~/.bash_colors
    source ~/.bash_preexec
    
    mul () {
        local mpc="$(construct-mpc-cmdline)"
        if echo $@ | grep -qx '\-f'; then
            $mpc -f '%file%' current
        else
            $mpc -f '%title% — %album% — %artist%' current
        fi
        $mpc -f '%genre%' current
        
        local supersets=($(mpdc collections find C | tail -n +3))
        echo -e "${White}    in:${Color_Off}" "${BWhite}${supersets[@]}${Color_Off}"
        echo -e "${White}not in:${Color_Off}" $( mpdc collections ls | grep -vxf <(printf "%s\n" "${supersets[@]}") )
    }

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

    __hr () { # __hr left_text right_text line_color
    #     printf "$1"'%*s\n' "$(($(tput cols) - ${#1}))" "$2" | sed 's/ /—/g';
    # 1 for text at left
    # 2 for text at ringt
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

    __do_not_print_when_started="true"
    __last_started=""
    __empty_command="false"

    preexec () {
        [[ $BASH_SUBSHELL -ne 0 ]] && return
        if [[ "__precmd" == "$BASH_COMMAND" ]]
        then
            __empty_command="true"
            return
        else
            __empty_command="false"
        fi

        __last_started="$(date '+%s')"
        __hr " ${IBlack}started at [$(date '+%H:%M:%S')]${Color_Off} "\
            ""\
            "${Blue}"
    }

    __precmd () {
        local returned=$?
        [[ $BASH_SUBSHELL -ne 0 ]] && return

        [[ "$__empty_command" == "true" ]] && return

        if [[ "$__do_not_print_when_started" = "true" ]]; then
            unset __do_not_print_when_started
            return
        fi

        if [[ $returned > 0 ]]; then
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
        local netns="$(ip netns identify)"
        if [ -n "${netns}" ]; then
            important_vars="${important_vars}netns: ${netns} "
        fi

        local protocol=''
        if [ -n "${SSH_TTY}" ]; then
            protocol="${protocol}${Purple}ssh${Color_Off}${IBlack}://${Color_Off}"
        fi

        spent="$(__displaytime $(( $(date '+%s') - __last_started )))"

        printf "${BWhite}${On_Red}↵${Color_Off}\n"
        __hr "${IBlack}finished at [$(date '+%H:%M:%S')] (took $spent) [${protocol}${Green}${USER}${IBlack}@$(hostname)${Color_Off} $(pwd | sed "s|$HOME|~|")${IBlack}] ${important_vars}"\
            "${returned_full}"\
            "${returned_hr_color}"

    }


    PROMPT_COMMAND="__precmd"
    preexec_install

    __hr "${IBlack}[$(date '+%H:%M:%S')] [${Green}${USER}${IBlack}@$(hostname)${Color_Off} $(pwd | sed "s|$HOME|~|")${IBlack}] "\
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

export NVM_DIR="/home/futpib/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
