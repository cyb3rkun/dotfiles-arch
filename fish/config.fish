# source /usr/share/cachyos-fish-config/cachyos-config.fish
# source ~/.config/fish/extra/cachyos-config.fish

# comon aliases

alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # Hardware Info

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
	# smth smth
end
# carapace _carapace | source

# kde necessities apperantly
# set -x XDG_DATA_DIRS $XDG_DATA_DIRS /usr/local/share /usr/share /var/lib/flatpak/exports/share $HOME/.local/share

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/cyb3r/.lmstudio/bin
set -gx QT_QPA_PLATFORMTHEME qt6ct

# End of LM Studio CLI section

# Ensure the universal SSH variables are exported to the environment
if test -n "$SSH_AUTH_SOCK"
    # Only export it if the socket file actually exists
    if test -S "$SSH_AUTH_SOCK"
        set -gx SSH_AUTH_SOCK "$SSH_AUTH_SOCK"
        set -gx SSH_AGENT_PID "$SSH_AGENT_PID"
    else
        # If the socket is dead, clear the stale universal variables
        set -e SSH_AUTH_SOCK
        set -e SSH_AGENT_PID
    end
end
# add the lux package manager library to lua's path
set -gx LUA_CPATH "$HOME/.local/share/lux/?.so;;"
set -gx LUA_PATH "$HOME/.local/share/lux/?.lua;;"
# add luxa namespace to lua's path
# set -gx LUA_CPATH "$HOME/.local/share/lux/luxa/?.so;;"
# set -gx LUA_PATH "$HOME/.local/share/lux/luxa/?.lua;;"
alias mt5="env WINEPREFIX=$HOME/.mt5 wine"
