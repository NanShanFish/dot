if status is-interactive
    if status is-login; and test "$TERM" = "linux"
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
		setfont /usr/share/kbd/consolefonts/iso02-12x22.psfu.gz
		clear
    end

	##  ALIAS  ##
	alias lt='exa -T'
	alias os='fastfetch'
	alias open='xdg-open'
	alias ta="tmux a > /dev/null || tmux"
	alias cin="xclip -selection clipboard -in"
	alias cout="xclip -selection clipboard -out"
	alias lzg='lazygit'
	alias lzd="lazydocker"
    abbr cp "cpg -g"
    abbr mv "mvg -g"

    ### fzf
    set --export FZF_DEFAULT_OPTS '--bind=ctrl-j:preview-down,ctrl-k:preview-up --cycle --layout=reverse --height=90% --marker="*"'
    bind \co '_fzf_search_directory'
    bind \cr '_fzf_search_history'
    bind \t '_fzf_complete'
end
