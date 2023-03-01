# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples
# Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
 autoload -Uz add-zsh-hook vcs_info
 # Enable substitution in the prompt.
 setopt prompt_subst
 # Run vcs_info just before a prompt is displayed (precmd)
 add-zsh-hook precmd vcs_info
 # add ${vcs_info_msg_0} to the prompt
 # e.g. here we add the Git information in red  
 #PROMPT='%1~ %F{red}${vcs_info_msg_0_}%f %# '
 
 # Enable checking for (un)staged changes, enabling use of %u and %c
 zstyle ':vcs_info:*' check-for-changes true
 # Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
 zstyle ':vcs_info:*' unstagedstr ' *'
 zstyle ':vcs_info:*' stagedstr ' +'
 # Set the format of the Git information for vcs_info
 zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
 zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
 #####################################################
 #RPROMPT='%F{92}${vcs_info_msg_0_}%f'
###################################################  
setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    blank=""
    prompt_symbol=@
    wlan0=$(ip addr | grep wlan0 | grep inet | awk '{print $2}' | awk -F "/" '{print $1}')
    if [[ $wlan0 != $blank ]]
    then
        THEIP="$wlan0"

    else
    fi
    if [[ $wlan0 == $blank ]]
    then
        THEIP="Offline"
    fi
    #㉿
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
          # PROMPT=$'%B%F{%(#.red.red)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{yellow}%n'$prompt_symbol$'%m%b%B%F{red})%B%F{80}~%B%F{red}[%B%F{85}%1d%B%F{red}]%B%F{92}${vcs_info_msg_0_}%f%F{%(#.blue.red)}\n└─%B%(#.%F{red}#.%F{155}$%F{70}(O_o))->%b%F{reset} '
           PROMPT=$'%B%F{%(#.red.red)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{yellow}%n'$prompt_symbol$'%m%b%B%F{red})%B%F{80}~%B%F{red}[%B%F{85}%1d%B%F{red}]%B%F{92}${vcs_info_msg_0_} \n%B%F{green}~ %B%F{87}>%b%F{reset} '
 
            # Right-side prompt with exit codes and background processes
            RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}. )'$'%B%F{111}[%F{170}%D{%L:%M:%S}%F{111}]'$'%B%F{93}[%B%F{40}$THEIP%B%F{93}]'
            ;;
        oneline)
            # PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
           PROMPT=$'%B%F{%(#.red.red)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{yellow}%n'$prompt_symbol$'%m%b%B%F{red})%B%F{80}~%B%F{red}[%B%F{85}%1d%B%F{red}]%B%F{92}${vcs_info_msg_0_} \n%B%F{green}~ %B%F{87}>%b%F{reset} '
 
            RPROMPT=
            ;;
        backtrack)
            # PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
           PROMPT=$'%B%F{%(#.red.red)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{yellow}%n'$prompt_symbol$'%m%b%B%F{red})%B%F{80}~%B%F{red}[%B%F{85}%1d%B%F{red}]%B%F{92}${vcs_info_msg_0_} \n%B%F{green}~ %B%F{87}>%b%F{reset} '
 
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
else
  #  PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
blank=""
prompt_symbol=@
wlan0=$(ip addr | grep wlan0 | grep inet | awk '{print $2}' | awk -F "/" '{print $1}')
data=$(ip addr | grep inet | grep data | awk '{print $2}' | awk -F "/" '{print $1}')
if [[ $wlan0 == $blank ]]
then
    THEIP=$data
elif [[ $data == $blank ]]
then
	THEIP=$wlan0
else
	THEIP="Offline"
fi
 PROMPT=$'%B%F{%(#.red.red)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{yellow}%n'$prompt_symbol$'%m%b%B%F{red})%B%F{80}~%B%F{red}[%B%F{85}%1d%B%F{red}]%B%F{92}${vcs_info_msg_0_} \n%B%F{green}~ %B%F{87}>%b%F{reset} '
 RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}. )'$'%B%F{111}[%F{170}%D{%L:%M:%S}%F{111}]'$'%B%F{93}[%B%F{40}$THEIP%B%F{93}]'
 
source /data/data/com.termux/files/home/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
#bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
    # alias emacsclient='emacsclient -c -a "emacs"'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# some more ls aliases
alias ll='ls -l'
alias lah='ls -lah'
alias la='exa -A'
alias l='exa -CF'
alias chak='cd /data/data/com.termux/files/home/storage/shared'
#alias proj='cd /home/chakrak/ws/proj'

# enable auto-suggestions based on the history
if [ -f ./zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . ./zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi
#-------------------------------------
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#---------------------------------------
#export __NV_PRIME_RENDER_OFFLOAD=1
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
#export __VK_LAYER_NV_optimus=NVIDIA_only
#export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
export PATH="/data/data/com.termux/files/home/.local/bin:$PATH"
export PATH="/data/data/com.termux/files/home/ws/bin:$PATH" #put this path is secure_path of sudoers
export PATH="/data/data/com.termux/files/home/.emacs.d/bin:$PATH"
export PATH="/data/data/com.termux/files/home/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="/data/data/com.termux/files/home/go/bin:$PATH"
export EDITOR=nvim
# nvim as manpager
# export MANPAGER="nvim -c 'set ft=man' -"

PATH="/data/data/com.termux/files/home/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/data/data/com.termux/files/home/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/data/data/com.termux/files/home/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/data/data/com.termux/files/home/perl5"; export PERL_MM_OPT;
#####################
chak
clear
