set -U fish_greeting ""
if status --is-login; and status --is-interactive
    if test "$TERM" = "linux"
        # echo -en "\e]P01F2229" #black
        echo -en "\e]P0000000" #black
        echo -en "\e]P88C42AB" #darkgrey
        echo -en "\e]P1D41919" #darkred
        echo -en "\e]P9EC0101" #red
        echo -en "\e]P25EBDAB" #darkgreen
        echo -en "\e]PA47D4B9" #green
        echo -en "\e]P3FEA44C" #brown
        echo -en "\e]PBFF8A18" #yellow
        echo -en "\e]P4367bf0" #darkblue
        echo -en "\e]PC277FFF" #blue
        echo -en "\e]P5BF2E5D" #darkmagenta
        echo -en "\e]PDD71655" #magenta
        echo -en "\e]P649AEE6" #darkcyan
        echo -en "\e]PE05A1F7" #cyan
        echo -en "\e]P7E6E6E6" #lightgrey
        echo -en "\e]PFFFFFFF" #white
        clear
    end
end

##  ALIAS  ##
#alias G='git'
alias lG='lazygit'
alias os='fastfetch'
alias open='xdg-open'
alias df="df -h -x tmpfs -x efivarfs | awk '!/^dev/'"
alias ta="tmux a"

###  ENVIRONMENT VARIABLES  ###
set -Ux EDITOR /bin/nvim
set -x BROWSER /bin/vivaldi-stable
set -Ux XDG_DOWNLOAD_DIR "$HOME/dls"
set -Ux XDG_DOCUMENTS_DIR "$HOME/doc"
set -Ux XDG_CONFIG_HOME "$HOME/.config"      # analogous to /etc
set -Ux XDG_CACHE_HOME "$HOME/.cache"        # analogous to /var/cache
set -Ux XDG_DATA_HOME "$HOME/.local/share"   # analogous to /usr/share
set -Ux DWM "$HOME/dwm"

bind \co '__fzf_find_file'
### fzf.fish
# Disable default keybinding
set -U FZF_DISABLE_KEYBINDINGS 1

# pnpm
set -gx PNPM_HOME "/home/shan/.local/share/pnpm"
# if not string match -q -- $PNPM_HOME $PATH
#   set -gx PATH "$PNPM_HOME" $PATH
# end
# pnpm end
