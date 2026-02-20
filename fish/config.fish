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

